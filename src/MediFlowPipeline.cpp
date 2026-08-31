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
    // ========================================
    // 1. INTAKE
    // ========================================

    const std::string intakeResult =
        intakeAgent.process(input);


    // ========================================
    // 2. EXTRACTION
    // ========================================

    const std::string extractionResult =
        extractionAgent.process(intakeResult);

    std::cout
        << "\nEXTRACTION RESULT:\n"
        << extractionResult
        << '\n';


    // ========================================
    // 3. JSON -> Patient
    // ========================================

    Patient patient;

    try
    {
        patient = patientFromJson(extractionResult);
    }
    catch (const json::parse_error& e)
    {
        throw std::runtime_error(
            std::string(
                "Extraction returned invalid JSON: "
            ) + e.what()
        );
    }


    // ========================================
    // 4. Patient -> JSON
    // ========================================

    const std::string patientJson =
        patientToJson(patient);


    // ========================================
    // 5. VALIDATION
    // ========================================

    const std::string validationResult =
        validationAgent.process(patientJson);

    std::cout
        << "\nVALIDATION RESULT:\n"
        << validationResult
        << '\n';


    // ========================================
    // 6. CHECK VALIDATION
    // ========================================

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
        validatedJson["validation"]["valid"]
            .get<bool>();


    if (!valid)
    {
        throw std::runtime_error(
            "Patient data is invalid."
        );
    }


    // ========================================
    // 7. ROUTING
    // ========================================

    const std::string routingResult =
        routingAgent.process(validationResult);

    std::cout
        << "\nROUTING RESULT:\n"
        << routingResult
        << '\n';


    // ========================================
    // 8. VERIFICATION
    // ========================================

    const std::string verificationResult =
        verificationAgent.process(routingResult);

    std::cout
        << "\nVERIFICATION RESULT:\n"
        << verificationResult
        << '\n';


    // ========================================
    // 9. CHECK FINAL APPROVAL
    // ========================================

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


    // ========================================
    // FINAL RESULT
    // ========================================

    return verificationResult;
}