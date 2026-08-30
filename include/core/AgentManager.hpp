#ifndef AGENT_MANAGER_H
#define AGENT_MANAGER_H

#include "agents/Agent.hpp"

#include <memory>
#include <vector>
#include <string>

class AgentManager
{
public:

    void addAgent(
        std::unique_ptr<Agent> agent
    );

    std::string process(
        const std::string& input
    );

private:

    std::vector<std::unique_ptr<Agent>> agents;
};

#endif