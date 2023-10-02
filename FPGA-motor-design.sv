// Sprint 3
// Name: Akshit Singh, ID: 221071548
// Code for connecting FPGA with DC motor for PWM clock cycles

module dc_motor (
    input [2:0]psw, // Switches to control PWM (bit 2 determines direction)
    output reg pdcm, // PWM output
    output dir,  // Direction output
    input clk  // System clock
);

reg [7:0] cnt = 8'b00000000;
reg [11:0] sclkdiv = 12'b000000000000;
wire clk1;

always @(posedge clk)
begin : P1
    cnt <= cnt + 1;
end

assign clk1 = cnt[7];

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
        pdcm <= 1'b1;  // At the beginning of PWM cycle, output is always high
    else 
        case (psw[1:0])  // Only take the last 2 bits for PWM control
            2'b00: if(sclkdiv == 12'b101011110000) pdcm <= 1'b0; // Motor OFF
            2'b01: if(sclkdiv == 12'b110011110000) pdcm <= 1'b0; // 25% duty cycle
            2'b10: if(sclkdiv == 12'b100011110000) pdcm <= 1'b0; // 50% duty cycle
            2'b11: if(sclkdiv == 12'b011011110000) pdcm <= 1'b0; // 75% duty cycle
        endcase
end

// Assign the direction based on the most significant bit of psw
assign dir = psw[2];

endmodule




