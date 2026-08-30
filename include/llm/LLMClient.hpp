#ifndef LLMCLIENT_H
#define LLMCLIENT_H

#include <string>

class LLMClient
{
public:

    LLMClient();

    std::string chat(const std::string& systemPrompt, const std::string& userMessage);

private:

    std::string apiKey;
    std::string model;
};

#endif