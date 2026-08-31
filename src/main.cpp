#include "MediFlowPipeline.hpp"

#include <nlohmann/json.hpp>

#include <iostream>
#include <string>

using json = nlohmann::json;

int main()
{
    try
    {
        LLMClient llmClient;

        MediFlowPipeline pipeline(&llmClient);

        const std::string input = R"(
            My name is Leumim Camuenga.
            I'm 24 years old.
            I have been sick for 3 days with head paining.
            My phone number is 923000000.
        )";

        const std::string result = pipeline.process(input);

        // Parse final result
        const json data = json::parse(result);

        std::cout << "\n";
        std::cout << "================================\n";
        std::cout << "          MEDIFLOW AI\n";
        std::cout << "================================\n";
        std::cout << "\n";

        const bool approved = data["verification"]["approved"].get<bool>();

        if (approved)
        {
            std::cout << "Patient verified successfully\n\n";
        }
        else
        {
            std::cout << "Patient verification failed\n\n";
        }

        std::cout << "Name: " << data["name"].get<std::string>()  << '\n';

        std::cout << "Age: " << data["age"].get<int>() << '\n';

        std::cout << "Reason: " << data["reason"].get<std::string>() << '\n';

        std::cout << "Duration: " << data["duration"].get<std::string>() << '\n';

        std::cout << "Phone: " << data["phone"].get<std::string>() << '\n';

        std::cout << "\nDepartment: " << data["routing"]["department"].get<std::string>()<< '\n';

        std::cout << "\nStatus: " << (approved ? "APPROVED" : "REJECTED") << '\n';

        std::cout << "================================\n";
    }
    catch (const std::exception& e)
    {
        std::cerr << "\nERROR:\n"  << e.what()  << '\n';

        return 1;
    }

    return 0;
}