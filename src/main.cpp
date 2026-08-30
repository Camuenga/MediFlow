#include <iostream>
#include <windows.h>

#include "llm/LLMClient.hpp"
#include "MediFlowPipeline.hpp"
#include "models/Patient.hpp"

#include <nlohmann/json.hpp>

using json = nlohmann::json;

int main()
{
    // UTF-8 no Windows
    SetConsoleOutputCP(CP_UTF8);
    SetConsoleCP(CP_UTF8);

    try
    {
        // ================================
        // LLM CLIENT
        // ================================
        LLMClient llmClient;

        // ================================
        // MEDIFLOW PIPELINE
        // ================================
        MediFlowPipeline pipeline(&llmClient);

        // ================================
        // PATIENT INPUT
        // ================================
        const std::string input = R"(
            My name is John Manuel. 
            I am 35 years old. 
            I have had a headache for three days. 
            My phone number is 923000000.
        )";

        // ================================
        // PROCESS PIPELINE
        // ================================
        const std::string result =
            pipeline.process(input);

        // ================================
        // PARSE FINAL RESULT
        // ================================
        const json data = json::parse(result);

        Patient patient =
            patientFromJson(result);

        // ================================
        // VERIFICATION
        // ================================
        bool approved = false;

        if (data.contains("verification") &&
            data["verification"].contains("approved") &&
            data["verification"]["approved"].is_boolean())
        {
            approved =
                data["verification"]["approved"].get<bool>();
        }

        // ================================
        // FINAL MEDIFLOW INTERFACE
        // ================================
        std::cout << "\n";
        std::cout << "================================\n";
        std::cout << "       MEDIFLOW AI\n";
        std::cout << "================================\n\n";

        if (approved)
        {
            std::cout
                << "Patient verified successfully\n\n";

            std::cout
                << "Name: "
                << patient.name
                << '\n';

            std::cout
                << "Age: "
                << patient.age
                << '\n';

            std::cout
                << "Reason: "
                << patient.reason
                << '\n';

            std::cout
                << "Duration: "
                << patient.duration
                << '\n';

            std::cout
                << "Phone: "
                << patient.phone
                << '\n';

            std::cout << "\n";
            std::cout
                << "Status: APPROVED\n";
        }
        else
        {
            std::cout
                << "Patient verification failed\n\n";

            std::cout
                << "Status: REJECTED\n";
        }

        std::cout
            << "================================\n";
    }
    catch (const std::exception& e)
    {
        std::cerr
            << "\nERROR:\n"
            << e.what()
            << '\n';

        return 1;
    }

    return 0;
}
