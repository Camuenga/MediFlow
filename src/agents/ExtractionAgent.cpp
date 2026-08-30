#include "agents/ExtractionAgent.hpp"

#include <iostream>
ExtractionAgent::ExtractionAgent(LLMClient* client) : llmClient(*client){

}
std::string ExtractionAgent::process(const std::string& input)
{
    std::cout << "\n[Extraction Agent]\n";

    const std::string systemPrompt = R"(
            You are the Information Extraction Agent
            of MediFlow AI.

            Your job is to extract administrative
            patient information from the conversation.

            Do not diagnose the patient.

            Extract only information explicitly
            provided by the patient.

            Return ONLY valid JSON.

            The JSON must contain exactly these fields:

            {
                "name": "",
                "age": 0,
                "reason": "",
                "duration": "",
                "phone": "",
                "documents": []
            }

            Rules:

            - Never invent information.
            - Only extract information explicitly
              provided by the patient.
            - If the name is not provided, use "".
            - If the age is not provided, use 0.
            - If the reason is not provided, use "".
            - If the duration is not provided, use "".
            - If the phone is not provided, use "".
            - If no documents are provided, use [].
        )";

    return llmClient.chat(systemPrompt,input);
}