#include "agents/VerificationAgent.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <string>

using json = nlohmann::json;

bool testApprovedPatient()
{
    VerificationAgent agent;

    const std::string input = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": [],
        "validation": {
            "valid": true
        }
    })";

    const json result = json::parse(agent.process(input));

    return result["verification"]["approved"].get<bool>() == true;
}

bool testRejectedPatient()
{
    VerificationAgent agent;

    const std::string input = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": [],
        "validation": {
            "valid": false
        }
    })";

    const json result = json::parse(agent.process(input));

    return result["verification"]["approved"].get<bool>() == false;
}

bool testMissingValidation()
{
    VerificationAgent agent;

    const std::string input = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["verification"]["approved"].get<bool>() == false;
}

int main()
{
    int passed = 0;
    int failed = 0;

    if (testApprovedPatient())
    {
        std::cout << "[PASS] Approved patient\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Approved patient\n";
        ++failed;
    }

    if (testRejectedPatient())
    {
        std::cout << "[PASS] Rejected patient\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Rejected patient\n";
        ++failed;
    }

    if (testMissingValidation())
    {
        std::cout << "[PASS] Missing validation\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Missing validation\n";
        ++failed;
    }

    std::cout << "\n============================\n";
    std::cout << "Verification Tests\n";
    std::cout << "Passed: " << passed << '\n';
    std::cout << "Failed: " << failed << '\n';
    std::cout << "============================\n";

    return failed == 0 ? 0 : 1;
}