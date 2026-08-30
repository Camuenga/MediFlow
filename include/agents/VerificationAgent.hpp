#ifndef VERIFICATION_AGENT_H
#define VERIFICATION_AGENT_H

#include "agents/Agent.hpp"

class VerificationAgent : public Agent
{
public:
    std::string process(
        const std::string& input
    ) override;
};

#endif