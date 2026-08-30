#ifndef MEDIFLOW_PIPELINE_H
#define MEDIFLOW_PIPELINE_H

#include <string>

#include "llm/LLMClient.hpp"

#include "agents/IntakeAgent.hpp"
#include "agents/ExtractionAgent.hpp"
#include "agents/ValidationAgent.hpp"
#include "agents/VerificationAgent.hpp"

class MediFlowPipeline
{
public:
    explicit MediFlowPipeline(LLMClient* client);

    std::string process(
        const std::string& input
    );

private:
    IntakeAgent intakeAgent;
    ExtractionAgent extractionAgent;
    ValidationAgent validationAgent;
    VerificationAgent verificationAgent;
};

#endif