#ifndef VALIDATION_AGENT_H
#define VALIDATION_AGENT_H

#include "agents/Agent.hpp"

class ValidationAgent : public Agent
{
public:
    std::string process(
        const std::string& input
    ) override;
};

#endif