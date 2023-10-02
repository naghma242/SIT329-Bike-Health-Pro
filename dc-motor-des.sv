// Code your design here
module dc_motor (psw, pdcm, clk);
input [2:0]psw; // 3 bit switch to control the DC motor
output reg pdcm;
input clk;
reg [7:0] cnt = 8'b00000000; //For every 8 clock pulses, divide the clock
reg [11:0] sclkdiv = 12'b000000000000; // To vary the speed of DC motor
wire clk1;

always @(posedge clk)
begin : P1
cnt <= cnt + 1;
end

assign clk1 = cnt[7];

always @(posedge clk1)
begin : P2
if (sclkdiv == 12'b101011110000)
begin
sclkdiv <= 12'b000000000000;
end
else
begin
sclkdiv <= sclkdiv + 1;
end
end

always @(posedge clk1)
begin : P3
if(sclkdiv == 12'b000000000000)
begin
pdcm <= 1'b1;
end
else if(psw == 3'b000 && sclkdiv == 12'b000111110100)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b001 && sclkdiv == 12'b001100100000)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b010 && sclkdiv == 12'b010001001100)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b011 && sclkdiv == 12'b010101111000)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b100 && sclkdiv == 12'b011010100100)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b101 && sclkdiv == 12'b011111010000)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b110 && sclkdiv == 12'b100011111100)
begin
pdcm <= 1'b0;
end
else if(psw == 3'b111 && sclkdiv == 12'b100111000100)
begin
pdcm <= 1'b0;
end
end

endmodule

