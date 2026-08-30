#include "core/AgentManager.hpp"

void AgentManager::addAgent(
    std::unique_ptr<Agent> agent)
{
    agents.push_back(
        std::move(agent)
    );
}

std::string AgentManager::process(
    const std::string& input)
{
    std::string data = input;

    for (auto& agent : agents)
    {
        data = agent->process(data);
    }

    return data;
}