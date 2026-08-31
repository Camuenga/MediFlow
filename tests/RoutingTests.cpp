#include "agents/RoutingAgent.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <string>

using json = nlohmann::json;

bool testDentistry()
{
    RoutingAgent agent;

    const std::string input = R"({
        "name": "John",
        "age": 35,
        "reason": "tooth pain",
        "duration": "2 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["routing"]["department"] == "Dentistry";
}

bool testOphthalmology()
{
    RoutingAgent agent;

    const std::string input = R"({
        "name": "John",
        "age": 35,
        "reason": "eye pain",
        "duration": "2 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["routing"]["department"] == "Ophthalmology";
}

bool testDermatology()
{
    RoutingAgent agent;

    const std::string input = R"({
        "name": "John",
        "age": 35,
        "reason": "skin problem",
        "duration": "2 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["routing"]["department"] == "Dermatology";
}

bool testGeneralConsultation()
{
    RoutingAgent agent;

    const std::string input = R"({
        "name": "John",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": []
    })";

    const json result = json::parse(agent.process(input));

    return result["routing"]["department"] == "General Consultation";
}

int main()
{
    int passed = 0;
    int failed = 0;

    if (testDentistry())
    {
        std::cout << "[PASS] Dentistry\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Dentistry\n";
        ++failed;
    }

    if (testOphthalmology())
    {
        std::cout << "[PASS] Ophthalmology\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Ophthalmology\n";
        ++failed;
    }

    if (testDermatology())
    {
        std::cout << "[PASS] Dermatology\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Dermatology\n";
        ++failed;
    }

    if (testGeneralConsultation())
    {
        std::cout << "[PASS] General Consultation\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] General Consultation\n";
        ++failed;
    }

    std::cout << "\n============================\n";
    std::cout << "Routing Tests\n";
    std::cout << "Passed: " << passed << '\n';
    std::cout << "Failed: " << failed << '\n';
    std::cout << "============================\n";

    return failed == 0 ? 0 : 1;
}