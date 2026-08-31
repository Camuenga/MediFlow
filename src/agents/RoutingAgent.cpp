#include "agents/RoutingAgent.hpp"

#include <nlohmann/json.hpp>
#include <iostream>
#include <algorithm>
#include <string>

using json = nlohmann::json;

std::string RoutingAgent::process(
    const std::string& input)
{
    std::cout << "\n[Routing Agent]\n";

    json patient = json::parse(input);

    if (!patient.contains("reason") ||
        !patient["reason"].is_string())
    {
        patient["routing"] = {
            {"department", "General Consultation"},
            {"reason", "Reason not provided"}
        };

        return patient.dump(4);
    }

    std::string reason = patient["reason"].get<std::string>();

    std::string lowerReason = reason;

    std::transform(
        lowerReason.begin(),
        lowerReason.end(),
        lowerReason.begin(),
        [](unsigned char c)
        {
            return std::tolower(c);
        }
    );

    std::string department = "General Consultation";

    if (lowerReason.find("tooth") != std::string::npos ||
        lowerReason.find("dental") != std::string::npos ||
        lowerReason.find("teeth") != std::string::npos)
    {
        department = "Dentistry";
    }
    else if (lowerReason.find("eye") != std::string::npos ||
             lowerReason.find("vision") != std::string::npos)
    {
        department = "Ophthalmology";
    }
    else if (lowerReason.find("skin") != std::string::npos)
    {
        department = "Dermatology";
    }
    else if (lowerReason.find("headache") != std::string::npos)
    {
        department = "General Consultation";
    }

    patient["routing"] = {
        {"department", department}
    };

    std::cout << "Department: " << department << '\n';

    return patient.dump(4);
}