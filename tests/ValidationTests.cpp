#include "agents/ValidationAgent.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <string>

using json = nlohmann::json;

bool testValidPatient()
{
    ValidationAgent agent;

    const std::string input = R"({
        "name": "Leumim Camuenga",
        "age": 24,
        "reason": "head paining",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["validation"]["valid"].get<bool>() == true;
}

bool testMissingPhone()
{
    ValidationAgent agent;

    const std::string input = R"({
        "name": "Leumim Camuenga",
        "age": 24,
        "reason": "head paining",
        "duration": "3 days",
        "phone": "",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["validation"]["valid"].get<bool>() == false;
}

bool testInvalidAge()
{
    ValidationAgent agent;

    const std::string input = R"({
        "name": "Leumim Camuenga",
        "age": 0,
        "reason": "head paining",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["validation"]["valid"].get<bool>() == false;
}

bool testMissingReason()
{
    ValidationAgent agent;

    const std::string input = R"({
        "name": "Leumim Camuenga",
        "age": 24,
        "reason": "",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["validation"]["valid"].get<bool>() == false;
}

int main()
{
    int passed = 0;
    int failed = 0;

    if (testValidPatient())
    {
        std::cout << "[PASS] Valid patient\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Valid patient\n";
        ++failed;
    }

    if (testMissingPhone())
    {
        std::cout << "[PASS] Missing phone\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Missing phone\n";
        ++failed;
    }

    if (testInvalidAge())
    {
        std::cout << "[PASS] Invalid age\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Invalid age\n";
        ++failed;
    }

    if (testMissingReason())
    {
        std::cout << "[PASS] Missing reason\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Missing reason\n";
        ++failed;
    }

    std::cout << "\n============================\n";
    std::cout << "Tests passed: " << passed << '\n';
    std::cout << "Tests failed: " << failed << '\n';
    std::cout << "============================\n";

    return failed == 0 ? 0 : 1;
}