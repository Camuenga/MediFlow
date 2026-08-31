#ifndef SERVER_H
#define SERVER_H

#include "llm/LLMClient.hpp"

class Server
{
public:
    explicit Server(LLMClient* client);

    void run();

private:
    LLMClient* client;
};

#endif