// Sprint 1 Code file
// Name: Akshit Singh, ID: 221071548
#include<iostream>

int main() {
    int BMI;
    const int basePower = 500;  // Base power of the bike when BMI is 0
    const int wattPerBMI = 10;  // Increase in power for every unit increase in BMI

    std::cout << "Enter your BMI: ";
    std::cin >> BMI;

    if(BMI < 0) {
        std::cout << "BMI cannot be negative." << std::endl;
        return 1;  // Exit with an error code
    }

    int adjustedPower = basePower + wattPerBMI * BMI;

    std::cout << "Based on your BMI, the power of the bike should be: " << adjustedPower << " watts." << std::endl;

    return 0;  // Exit successfully
}
