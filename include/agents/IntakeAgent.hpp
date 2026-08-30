#ifndef INTAKE_AGENT_H
#define INTAKE_AGENT_H

#include "agents/Agent.hpp"

class IntakeAgent : public Agent
{
public:
    std::string process(
        const std::string& input
    ) override;
};

#endif