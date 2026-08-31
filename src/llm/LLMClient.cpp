#include "llm/LLMClient.hpp"

#include <cstdlib>
#include <curl/curl.h>
#include <stdexcept>
#include <string>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

namespace
{
    std::size_t writeCallback(
        void* contents,
        std::size_t size,
        std::size_t nmemb,
        void* userData)
    {
        const std::size_t totalSize = size * nmemb;

        auto* response =
            static_cast<std::string*>(userData);

        response->append(
            static_cast<char*>(contents),
            totalSize
        );

        return totalSize;
    }
}

LLMClient::LLMClient()
{
    const char* key = std::getenv("GROQ_API_KEY");

    if (!key || std::string(key).empty())
    {
        throw std::runtime_error(
            "GROQ_API_KEY was not found."
        );
    }

    apiKey = key;

    const char* modelName = std::getenv("MEDIFLOW_MODEL");

    if (!modelName || std::string(modelName).empty())
    {
        throw std::runtime_error(
            "MEDIFLOW_MODEL was not defined."
        );
    }

    model = modelName;

    curl_global_init(CURL_GLOBAL_DEFAULT);
}

std::string LLMClient::chat(
    const std::string& systemPrompt,
    const std::string& userMessage)
{
    CURL* curl = curl_easy_init();

    if (!curl)
    {
        throw std::runtime_error(
            "Failure to initialize libcurl."
        );
    }

    /*
     * Groq utiliza o formato OpenAI Chat Completions.
     */
    json request;

    request["model"] = model;

    request["messages"] = json::array({
        {
            {"role", "system"},
            {"content", systemPrompt}
        },
        {
            {"role", "user"},
            {"content", userMessage}
        }
    });

    const std::string requestBody = request.dump();

    std::string response;

    curl_slist* headers = nullptr;

    headers = curl_slist_append(
        headers,
        "Content-Type: application/json"
    );

    const std::string authorization = "Authorization: Bearer " + apiKey;

    headers = curl_slist_append(
        headers,
        authorization.c_str()
    );

    curl_easy_setopt(
        curl,
        CURLOPT_URL,
        "https://api.groq.com/openai/v1/chat/completions"
    );

    curl_easy_setopt(
        curl,
        CURLOPT_HTTPHEADER,
        headers
    );

    curl_easy_setopt(
        curl,
        CURLOPT_POST,
        1L
    );

    curl_easy_setopt(
        curl,
        CURLOPT_POSTFIELDS,
        requestBody.c_str()
    );

    curl_easy_setopt(
        curl,
        CURLOPT_WRITEFUNCTION,
        writeCallback
    );

    curl_easy_setopt(
        curl,
        CURLOPT_WRITEDATA,
        &response
    );

    curl_easy_setopt(
        curl,
        CURLOPT_CAINFO,
        "C:/msys64/mingw64/etc/ssl/certs/ca-bundle.crt"
    );

    CURLcode result = curl_easy_perform(curl);

    if (result != CURLE_OK)
    {
        const std::string error = curl_easy_strerror(result);

        curl_slist_free_all(headers);
        curl_easy_cleanup(curl);

        throw std::runtime_error(
            "CURL error: " + error
        );
    }

    long httpCode = 0;

    curl_easy_getinfo(
        curl,
        CURLINFO_RESPONSE_CODE,
        &httpCode
    );

    curl_slist_free_all(headers);
    curl_easy_cleanup(curl);

    if (httpCode < 200 || httpCode >= 300)
    {
        throw std::runtime_error(
            "API returned HTTP " +
            std::to_string(httpCode) +
            "\nResponse: " +
            response
        );
    }

    const json responseJson = json::parse(response);

    return responseJson.at("choices").at(0).at("message").at("content").get<std::string>();
}