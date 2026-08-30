#ifndef AGENT_H
#define AGENT_H

#include <string>

class Agent
{
public:
    virtual ~Agent() = default;

    virtual std::string process(
        const std::string& input
    ) = 0;
};

#endif