#include "agents/ValidationAgent.hpp"
#include "agents/RoutingAgent.hpp"
#include "agents/VerificationAgent.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <string>

using json = nlohmann::json;

bool testValidPipelineData()
{
    ValidationAgent validationAgent;
    RoutingAgent routingAgent;
    VerificationAgent verificationAgent;

    const std::string patient = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "tooth pain",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    // Validation
    const json validation =
        json::parse(validationAgent.process(patient));

    if (!validation["validation"]["valid"].get<bool>())
        return false;

    // Routing
    const json routing =
        json::parse(routingAgent.process(validation.dump()));

    if (routing["routing"]["department"] != "Dentistry")
        return false;

    // Verification
    const json verification =
        json::parse(verificationAgent.process(routing.dump()));

    return verification["verification"]["approved"].get<bool>();
}

bool testInvalidPipelineData()
{
    ValidationAgent validationAgent;

    const std::string patient = R"({
        "name": "John Manuel",
        "age": 0,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    const json validation =
        json::parse(validationAgent.process(patient));

    return validation["validation"]["valid"].get<bool>() == false;
}

bool testMissingPhone()
{
    ValidationAgent validationAgent;

    const std::string patient = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "",
        "documents": []
    })";

    const json validation =
        json::parse(validationAgent.process(patient));

    return validation["validation"]["valid"].get<bool>() == false;
}

int main()
{
    int passed = 0;
    int failed = 0;

    if (testValidPipelineData())
    {
        std::cout << "[PASS] Valid patient pipeline\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Valid patient pipeline\n";
        ++failed;
    }

    if (testInvalidPipelineData())
    {
        std::cout << "[PASS] Invalid patient pipeline\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Invalid patient pipeline\n";
        ++failed;
    }

    if (testMissingPhone())
    {
        std::cout << "[PASS] Missing phone pipeline\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Missing phone pipeline\n";
        ++failed;
    }

    std::cout << "\n================================\n";
    std::cout << "MediFlow Pipeline Tests\n";
    std::cout << "Passed: " << passed << '\n';
    std::cout << "Failed: " << failed << '\n';
    std::cout << "================================\n";

    return failed == 0 ? 0 : 1;
}