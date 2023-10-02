// Sprint 3
// Name: Akshit Singh, ID: 221071548
// Altered the code to make sure your FPGA's PWM generator operates within the PWM's frequency range of MD10C R3

module tb_dc_motor;

    reg [2:0] psw_tb;
    reg clk_tb;
    wire pdcm_tb;
    wire dir_tb;

    // Instantiate the dc_motor design with the desired PWM cycles and counter reset values
    dc_motor #(
        .PWM_OFF(12'b101011110000),
        .PWM_25(12'b110011110000),
        .PWM_50(12'b100011110000),
        .PWM_75(12'b011011110000),
        .CNT_RESET(8'b11111111),         // Modify as needed
        .SCLKDIV_RESET(12'b101011110000) // Modify as needed
    ) DUT (
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

        psw_tb = 3'b111;  // Not explicitly defined in the design, so it might default to some state (you might want to handle this in your design)
        #20;

        $stop;  // End the simulation
    end

    // Simple monitor to display values
    initial begin
        $monitor("At time %0d: psw = %b, pdcm = %b, dir = %b", $time, psw_tb, pdcm_tb, dir_tb);
    end

endmodule
