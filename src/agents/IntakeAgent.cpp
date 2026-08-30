#include "agents/IntakeAgent.hpp"

#include <iostream>

std::string IntakeAgent::process(
    const std::string& input)
{
    std::cout << "\n[Intake Agent]\n";
    std::cout << "Paciente informou:\n";
    std::cout << input << '\n';

    return input;
}