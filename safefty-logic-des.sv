module dc_motor (
    input [2:0] psw, 
    output reg pdcm,
    output dir,
    input clk,
    input fault_in,  // Input signal indicating a fault
    output reg fault_out // Signal indicating a detected fault
);

reg [12:0] cnt = 13'b0;
reg [11:0] sclkdiv = 12'b000000000000;
reg [15:0] safety_cnt = 16'd0;
wire clk1;
reg prev_psw = 3'b0;
reg ramp_enable = 0;

always @(posedge clk)
begin : P1
 if(cnt == 13'd5000)
        cnt <= 13'b0;
    else
        cnt <= cnt + 1;
end

assign clk1 = cnt[12];

always @(posedge clk1)
begin : P2
    if (sclkdiv == 12'b101011110000)
        sclkdiv <= 12'b000000000000;
    else
        sclkdiv <= sclkdiv + 1;
end

always @(posedge clk1)
begin : P3
    if(sclkdiv == 12'b000000000000)
        pdcm <= 1'b1; 
    else if (fault_in) 
        pdcm <= 1'b0;  // Shut off the motor if a fault is detected
 else if (ramp_enable)
        pdcm <= ~(pdcm);  // Toggle PWM output for a ramp-up effect
    else 
        case (psw[1:0])  
            2'b00: if(sclkdiv == 12'b101011110000) pdcm <= 1'b0; 
            2'b01: if(sclkdiv == 12'b110011110000) pdcm <= 1'b0; 
            2'b10: if(sclkdiv == 12'b100011110000) pdcm <= 1'b0; 
            2'b11: if(sclkdiv == 12'b011011110000) pdcm <= 1'b0; 
        endcase
end

always @(posedge clk) 
begin
    if (prev_psw != psw) 
    begin
        safety_cnt <= 16'd0;
        prev_psw <= psw;
        if(psw[2] != prev_psw[2])  // Detect a direction change
            ramp_enable <= 1;  // Enable ramp-up
        else
            ramp_enable <= 0;
    end
else if (safety_cnt == 16'd50000) 
        pdcm <= 1'b0;  // Safety timeout: Turn off the motor if no change in input for some time
    else 
        safety_cnt <= safety_cnt + 1;
end

// Fault output logic
always @(posedge clk)
begin
    if (fault_in)
        fault_out <= 1'b1;
    else
        fault_out <= 1'b0;
end
assign dir = psw[2];
endmodule
