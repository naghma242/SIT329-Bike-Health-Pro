module adc_interface (
    input clk,              // System clock
    input reset,            // Active-high reset
    output reg convst,      // Conversion start signal
    output reg sck,         // SPI clock
    output reg sdi,         // Serial Data Input (FPGA to ADC)
    input sdo,              // Serial Data Out (ADC to FPGA)
    output reg [11:0] adc_value  // 12-bit ADC result
);

    // Define states for SPI communication using parameters
    parameter IDLE = 2'b00, START_CONV = 2'b01, READ_DATA = 2'b10;
    reg [1:0] current_state = IDLE, next_state = IDLE;

    integer bit_count = 0;  // Counter for bits received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count <= 0;
            adc_value <= 0;
            sck <= 0;
            sdi <= 0;     // Ensure sdi has an assignment here
            convst <= 1;  // Idle high
        end else begin
            current_state <= next_state;
            case(current_state)
                IDLE: begin
                    convst <= 1;
                    sck <= 0;
                    sdi <= 0;  // Ensure sdi has an assignment in all cases
                    bit_count <= 0;
                    adc_value <= 0;
                    next_state <= START_CONV;
                end

                START_CONV: begin
                    convst <= 0;  // Start ADC conversion
                    sdi <= 0;     // Ensure sdi has an assignment in all cases
                    if (bit_count < 4) begin  // Wait for a few clocks
                        bit_count <= bit_count + 1;
                        next_state <= START_CONV;  // Remain in this state
                    end else begin
                        bit_count <= 0;
                        next_state <= READ_DATA;
                    end
                end

                READ_DATA: begin
                    sck <= ~sck;  // Toggle clock for SPI
                    sdi <= 0;     // Ensure sdi has an assignment in all cases
                    if (sck) begin  // Capture data on rising edge
                        adc_value <= {adc_value[10:0], sdo};  // Shift in the received bit
                        bit_count <= bit_count + 1;
                        if (bit_count == 12) next_state <= IDLE;  // After reading 12 bits
                        else next_state <= READ_DATA;            // Continue reading
                    end
                end
            endcase
        end
    end

endmodule
