#ifndef ROUTING_AGENT_H
#define ROUTING_AGENT_H

#include "agents/Agent.hpp"

class RoutingAgent : public Agent
{
public:
    std::string process(
        const std::string& input
    ) override;
};

#endif