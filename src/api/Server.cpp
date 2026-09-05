#include "Server.hpp"
#define CROW_FEATURE_STATIC_DIRECTORY 0
#include <crow.h>
#include <nlohmann/json.hpp>

#include <iostream>

using json = nlohmann::json;

Server::Server(LLMClient* client)
    : client(client),
      pipeline(client)
{
}

void Server::run()
{
    crow::SimpleApp app;
        CROW_ROUTE(app, "/api/health")
        ([]()
        {
            json response = {
                {"status", "ok"},
                {"service", "MediFlow AI"}
            };

            crow::response res(
                200,
                response.dump()
            );

            res.set_header(
                "Content-Type",
                "application/json"
            );

            return res;
        });
    CROW_ROUTE(app, "/api/intake")
        .methods(crow::HTTPMethod::POST)
        ([this](const crow::request& req)
        {
            try
            {
                json body = json::parse(req.body);

                if (!body.contains("message") ||
                    !body["message"].is_string())
                {
                    return crow::response(
                        400,
                        R"({"error":"Message is required"})"
                    );
                }

                const std::string message = body["message"].get<std::string>();

                const std::string result = pipeline.process(message);

                crow::response response(200, result);
                response.set_header(
                    "Content-Type",
                    "application/json"
                );

                return response;
            }
            catch (const std::exception& e)
            {
                json error;

                error["error"] = e.what();

                crow::response response(
                    500,
                    error.dump()
                );
                response.set_header("Content-Type","application/json");
                return response;
            }
        });

    std::cout << "MediFlow API running on port 8080...\n";

    app.port(8080).multithreaded().run();
}