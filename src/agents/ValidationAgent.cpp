#include "agents/ValidationAgent.hpp"
#include <nlohmann/json.hpp>

#include <iostream>

using json = nlohmann::json;

std::string ValidationAgent::process(
    const std::string& input)
{
    std::cout << "\n[Validation Agent]\n";

    json patient;

    try
    {
        patient = json::parse(input);
    }
    catch (const json::parse_error& e)
    {
        std::cout << "Invalid JSON\n";

        json result;

        result["validation"] = {
            {"valid", false},
            {"error", "Invalid JSON"}
        };

        return result.dump(4);
    }

    bool valid = true;

   if (!patient.contains("name") || !patient["name"].is_string() || patient["name"].get<std::string>().empty())
    {
        std::cout << "Missing: name\n";
        valid = false;
    }

    if (!patient.contains("age") || !patient["age"].is_number_integer() || patient["age"].get<int>() <= 0 || patient["age"].get<int>() > 150)
    {
        std::cout << "Invalid: age\n";
        valid = false;
    }

    if (!patient.contains("reason") || !patient["reason"].is_string() || patient["reason"].get<std::string>().empty())
    {
        std::cout << "Missing: reason\n";
        valid = false;
    }

    if (!patient.contains("phone") || !patient["phone"].is_string() || patient["phone"].get<std::string>().empty())
    {
        std::cout << "Missing: phone\n";
        valid = false;
    }

    patient["validation"] = {
        {"valid", valid}
    };

    return patient.dump(4);
}