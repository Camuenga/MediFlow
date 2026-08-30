#ifndef EXTRACTION_AGENT_H
#define EXTRACTION_AGENT_H

#include "agents/Agent.hpp"
#include "llm/LLMClient.hpp"

class ExtractionAgent : public Agent
{
public:
    explicit ExtractionAgent(LLMClient* client);
    std::string process(const std::string& input) override;
private:
    LLMClient& llmClient;
};

#endif