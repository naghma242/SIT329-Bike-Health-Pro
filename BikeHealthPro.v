// The BikeHealthPro module is designed to control a motor's speed based on an individual's BMI.
module BikeHealthPro (
    input clk,                  // System clock input
    input reset,                // System reset input
    output reg pdcm,            // Control signal for the DC motor
    output dir,                 // Direction control
    input fault_in,             // Fault input (from some external protection circuit maybe)
    output reg fault_out,       // Fault output, used to indicate a detected fault
    output [1:0] leds,          // 2-bit LED output for indication
    output reg [2:0] psw,       // 3-bit switch input for user control
    input [7:0] in_height,      // External input representing the height of the person
    input [6:0] in_weight       // External input representing the weight of the person
);

    // Clock division logic for generating a slower clock 'clk1' from the main clock
    reg [12:0] cnt = 13'b0;
    reg [11:0] sclkdiv = 12'b000000000000;
    wire clk1;

    reg [2:0] prev_psw = 3'b0;
    reg ramp_enable = 0;

    reg [7:0] height;             
    reg [6:0] weight;             
    reg [5:0] bmi;                
    reg [3:0] speed_level;

    reg led_increase = 0;
    reg led_decrease = 0;

    // Define parameter values for BMI calculation
    parameter BMI_MIN = 15;
    parameter BMI_MAX = 30;
    parameter SPEED_MIN = 1; 
    parameter SPEED_MAX = 10;

    // Clock divider logic - divides the main clock to generate clk1
    always @(posedge clk or posedge reset) begin
        if (reset) cnt <= 13'b0;
        else if (cnt == 13'd5000) cnt <= 13'b0;
        else cnt <= cnt + 1;
    end

    // Deriving a slower clock from the primary system clock
    assign clk1 = cnt[12];

    always @(posedge clk1) begin
        if (sclkdiv == 12'b101011110000) sclkdiv <= 12'b000000000000;
        else sclkdiv <= sclkdiv + 1;
    end

    // Initialize variables for BMI calculation and control logic
    initial begin
        pdcm = 1'b0;
        fault_out = 1'b0;
        psw = 3'b0;
        height = 8'b0;
        weight = 7'b0;
        bmi = 6'b0;
        speed_level = 4'b0;
        ramp_enable = 0;
        prev_psw = 3'b0;
        led_increase = 0;
        led_decrease = 0;
    end

    // Core logic for BMI calculation, motor control, and LED status updates
    always @(posedge clk1 or posedge reset) begin
        if (reset) begin
            // Initialize variables upon system reset
            pdcm <= 1'b0;
            fault_out <= 1'b0;
            psw <= 3'b0;
            height <= 8'b0;
            weight <= 7'b0;
            bmi <= 6'b0;
            speed_level <= 4'b0;
            ramp_enable <= 0;
            prev_psw <= 3'b0;
            led_increase <= 0;
            led_decrease <= 0;
        end else begin
            // BMI calculation based on given height and weight
            bmi <= (weight * 100 * 100) / (height * height);

            // Motor control logic based on BMI and user inputs
            if (sclkdiv == 12'b000000000000) pdcm <= 1'b1;
            else if (fault_in) pdcm <= 1'b0;  
            else if (sclkdiv == 12'd50000) pdcm <= 1'b0;  
            else begin
                case (psw[1:0])  
                    2'b00: pdcm <= (sclkdiv == 12'b101011110000) ? 1'b0 : pdcm; 
                    2'b01: pdcm <= (sclkdiv == 12'b110011110000) ? 1'b0 : pdcm; 
                    2'b10: pdcm <= (sclkdiv == 12'b100011110000) ? 1'b0 : pdcm; 
                    2'b11: pdcm <= (sclkdiv == 12'b011011110000) ? 1'b0 : pdcm; 
                endcase
            end

            // LED control logic based on speed level
            led_increase <= (speed_level > prev_speed_level);
            led_decrease <= (speed_level < prev_speed_level);
            
            // Output fault signal if any fault is detected
            fault_out <= fault_in;
        end
    end

    // Logic to store the previous speed level for comparison in the next cycle
    reg [3:0] prev_speed_level;
    always @(posedge clk1) prev_speed_level <= speed_level;

    // Assignments for LED outputs and direction control
    assign leds = {led_increase, led_decrease};
    assign dir = psw[2];

endmodule
