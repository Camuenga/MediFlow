#ifndef SERVER_H
#define SERVER_H

#include "llm/LLMClient.hpp"
#include "MediFlowPipeline.hpp"

class Server
{
public:
    explicit Server(LLMClient* client);

    void run();

private:
    LLMClient* client;
    MediFlowPipeline pipeline;
};

#endif

