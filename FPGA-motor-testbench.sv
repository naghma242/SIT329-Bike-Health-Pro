// Sprint 3
// Name: Akshit Singh, ID: 221071548
// FPGA-motor-testbench.sv
module tb_dc_motor;

    reg [2:0] psw_tb;
    reg clk_tb;
    wire pdcm_tb;
    wire dir_tb;

    // Instantiate the dc_motor design
    dc_motor DUT (
        .psw(psw_tb),
        .pdcm(pdcm_tb),
        .dir(dir_tb),
        .clk(clk_tb)
    );

    // Clock generation
    always begin
        #5 clk_tb = ~clk_tb;
    end

    // Testbench stimuli
    initial begin
        clk_tb = 0;
        psw_tb = 3'b000;  // Motor OFF
        #20;

        psw_tb = 3'b001;  // 25% duty cycle, forward direction
        #20;

        psw_tb = 3'b010;  // 50% duty cycle, forward direction
        #20;

        psw_tb = 3'b011;  // 75% duty cycle, forward direction
        #20;

        psw_tb = 3'b100;  // 25% duty cycle, reverse direction
        #20;

        psw_tb = 3'b101;  // 50% duty cycle, reverse direction
        #20;

        psw_tb = 3'b110;  // 75% duty cycle, reverse direction
        #20;

        psw_tb = 3'b111;  // Not explicitly defined in your design, so it might default to some state (you might want to handle this in your design)
        #20;

        $stop;  // End the simulation
    end

    // Simple monitor to display values
    initial begin
        $monitor("At time %0d: psw = %b, pdcm = %b, dir = %b", $time, psw_tb, pdcm_tb, dir_tb);
    end

endmodule






