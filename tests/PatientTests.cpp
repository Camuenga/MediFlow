#include "models/Patient.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <string>

using json = nlohmann::json;

bool testPatientFromJson()
{
    const std::string input = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": ["ID", "insurance"]
    })";

    Patient patient = patientFromJson(input);

    return patient.name == "John Manuel" &&
           patient.age == 35 &&
           patient.reason == "headache" &&
           patient.duration == "3 days" &&
           patient.phone == "923000000" &&
           patient.documents.size() == 2;
}

bool testPatientToJson()
{
    Patient patient;

    patient.name = "John Manuel";
    patient.age = 35;
    patient.reason = "headache";
    patient.duration = "3 days";
    patient.phone = "923000000";
    patient.documents = {"ID", "insurance"};

    const json result = json::parse(
        patientToJson(patient)
    );

    return result["name"] == "John Manuel" &&
           result["age"] == 35 &&
           result["reason"] == "headache" &&
           result["duration"] == "3 days" &&
           result["phone"] == "923000000" &&
           result["documents"].size() == 2;
}

bool testPatientRoundTrip()
{
    const std::string input = R"({
        "name": "John Manuel",
        "age": 35,
        "reason": "headache",
        "duration": "3 days",
        "phone": "923000000",
        "documents": ["ID"]
    })";

    Patient patient = patientFromJson(input);

    const json result = json::parse(
        patientToJson(patient)
    );

    return result["name"] == "John Manuel" &&
           result["age"] == 35 &&
           result["reason"] == "headache" &&
           result["duration"] == "3 days" &&
           result["phone"] == "923000000" &&
           result["documents"].size() == 1;
}

int main()
{
    int passed = 0;
    int failed = 0;

    if (testPatientFromJson())
    {
        std::cout << "[PASS] JSON -> Patient\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] JSON -> Patient\n";
        ++failed;
    }

    if (testPatientToJson())
    {
        std::cout << "[PASS] Patient -> JSON\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Patient -> JSON\n";
        ++failed;
    }

    if (testPatientRoundTrip())
    {
        std::cout << "[PASS] Patient round-trip\n";
        ++passed;
    }
    else
    {
        std::cout << "[FAIL] Patient round-trip\n";
        ++failed;
    }

    std::cout << "\n============================\n";
    std::cout << "Patient Tests\n";
    std::cout << "Passed: " << passed << '\n';
    std::cout << "Failed: " << failed << '\n';
    std::cout << "============================\n";

    return failed == 0 ? 0 : 1;
}