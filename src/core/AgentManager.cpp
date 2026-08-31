#include "core/AgentManager.hpp"

void AgentManager::addAgent(
    std::unique_ptr<Agent> agent)
{
    if(!agent){
        throw std::invalid_argument("Cannot add a null agent.");
    }
    agents.push_back(std::move(agent));
}

std::string AgentManager::process(
    const std::string& input)
{
    std::string data = input;

    for (auto& agent : agents)
    {
        if(!agent){
            throw std::runtime_error("AgentManager contains a null agent.");
        }
        data = agent->process(data);
    }

    return data;
}