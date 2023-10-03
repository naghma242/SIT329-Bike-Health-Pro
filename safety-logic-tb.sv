module tb_dc_motor;
reg [2:0] psw_tb;
reg clk_tb;
wire pdcm_tb;
wire dir_tb;
reg fault_in_tb;  // Introducing fault input for testbench
wire fault_out_tb;
dc_motor DUT (
    .psw(psw_tb),
    .pdcm(pdcm_tb),
    .dir(dir_tb),
    .clk(clk_tb),
    .fault_in(fault_in_tb),  // Connect to the fault input
    .fault_out(fault_out_tb) // Monitor fault output
);
always begin
    #5 clk_tb = ~clk_tb;
end
initial begin
    clk_tb = 0;
    fault_in_tb = 0;
    psw_tb = 3'b000;
    #1000;
    psw_tb = 3'b001;
    #1000;
    psw_tb = 3'b010;
    #1000;
    fault_in_tb = 1;  // Introduce a fault
    #100;
    fault_in_tb = 0;  // Clear the fault
    #900;
    psw_tb = 3'b011;
    #1000;
    psw_tb = 3'b100;
    #1000;
    psw_tb = 3'b101;
    #1000;
    psw_tb = 3'b110;
    #1000;
    psw_tb = 3'b111;
    #1000;
    $finish;
end
endmodule
