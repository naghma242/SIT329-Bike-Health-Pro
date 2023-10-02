module RandomInputToBmi (
  output reg [7:0] height, // Random input height (100 to 250)
  output reg [6:0] weight, // Random input weight (20 to 120)
  output reg [5:0] bmi, // Calculated BMI value
  output reg [3:0] speed_level // Speed level (1 to 10)
);
  // Define parameter values
  parameter BMI_MIN = 15;
  parameter BMI_MAX = 30;
  parameter SPEED_MIN = 1; // Minimum speed level
  parameter SPEED_MAX = 10; // Maximum speed level
  
  // Generate random inputs height and weight
  initial begin
    // Generate random values for height and weight within specified ranges
    height = $urandom_range(120, 200);
    weight = $urandom_range(20, 120);
    
    // Calculate BMI using the formula
    bmi = (weight * 100 * 100) / (height * height);
    
    // Map BMI value to speed levels
    if (bmi <= BMI_MIN)
      speed_level = SPEED_MAX;
    else if (bmi >= BMI_MAX)
      speed_level = SPEED_MIN;
    else begin
      // Linear mapping formula; adjust as needed
      speed_level = (SPEED_MAX - SPEED_MIN) * (bmi - BMI_MIN) / (BMI_MAX - BMI_MIN) + SPEED_MIN;
    end
    
    // Display the values
    $display("height = %d, weight = %d, bmi = %d, speed_level = %d", height, weight, bmi, speed_level);
  end
endmodule
