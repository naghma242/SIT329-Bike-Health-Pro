
module tb_dc_motor();

  reg [2:0] psw;
  reg clk;
  wire pdcm;
  
  dc_motor u0 (.psw(psw), .pdcm(pdcm), .clk(clk));

  // Clock Generation
  always begin
    #5 clk = ~clk;
  end

  // Testbench Logic
  initial begin
    clk = 0;
    psw = 3'b000;
    #40;  // Shortened delay

    psw = 3'b001;
    #40;

    psw = 3'b010;
    #40;

    psw = 3'b011;
    #40;

    psw = 3'b100;
    #40;

    psw = 3'b101;
    #40;

    psw = 3'b110;
    #40;

    psw = 3'b111;
    #40;

    $finish; // End the simulation using $finish
  end
  
endmodule

