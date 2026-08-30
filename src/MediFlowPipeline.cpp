#include "MediFlowPipeline.hpp"

#include "models/Patient.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <stdexcept>

using json = nlohmann::json;

MediFlowPipeline::MediFlowPipeline(
    LLMClient* client)
    : extractionAgent(client)
{
}

std::string MediFlowPipeline::process(
    const std::string& input)
{
    // 1. Intake
    const std::string intakeResult =
        intakeAgent.process(input);

    // 2. Extraction
    const std::string extractionResult =
        extractionAgent.process(intakeResult);

    std::cout
        << "\nEXTRACTION RESULT:\n"
        << extractionResult
        << '\n';

    // 3. Convert extracted JSON -> Patient
    Patient patient;

    try
    {
        patient =
            patientFromJson(extractionResult);
    }
    catch (const json::parse_error& e)
    {
        throw std::runtime_error(
            std::string(
                "Extraction returned invalid JSON: "
            ) + e.what()
        );
    }

    // 4. Convert Patient -> JSON
    const std::string patientJson =
        patientToJson(patient);

    // 5. Validation
    const std::string validationResult =
        validationAgent.process(patientJson);

    std::cout
        << "\nVALIDATION RESULT:\n"
        << validationResult
        << '\n';

    // 6. Verify validation structure
    json validatedJson;

    try
    {
        validatedJson =
            json::parse(validationResult);
    }
    catch (const json::parse_error& e)
    {
        throw std::runtime_error(
            std::string(
                "Validation returned invalid JSON: "
            ) + e.what()
        );
    }

    if (!validatedJson.contains("validation") ||
        !validatedJson["validation"].contains("valid"))
    {
        throw std::runtime_error(
            "Validation result is invalid."
        );
    }

    const bool valid =
        validatedJson["validation"]["valid"].get<bool>();

    if (!valid)
    {
        throw std::runtime_error(
            "Patient data is invalid."
        );
    }

    // 7. Verification
    const std::string verificationResult =
        verificationAgent.process(
            validationResult
        );

    std::cout
        << "\nVERIFICATION RESULT:\n"
        << verificationResult
        << '\n';

    // 8. Verify final approval
    const json verifiedJson =
        json::parse(verificationResult);

    if (!verifiedJson.contains("verification") ||
        !verifiedJson["verification"].contains("approved"))
    {
        throw std::runtime_error(
            "Verification result is invalid."
        );
    }

    const bool approved =
        verifiedJson["verification"]["approved"]
            .get<bool>();

    if (!approved)
    {
        throw std::runtime_error(
            "Patient verification failed."
        );
    }

    return verificationResult;
}