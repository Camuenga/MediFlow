cmake_minimum_required(VERSION 3.16)

project(MediFlow
    VERSION 1.0
    LANGUAGES CXX
)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CURL_INCLUDE_DIR "C:/msys64/mingw64/include")


include(FetchContent)

FetchContent_Declare(
    json
    URL https://github.com/nlohmann/json/releases/download/v3.12.0/json.tar.xz
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
FetchContent_MakeAvailable(json)

add_executable(MediFlow

    src/main.cpp
    src/MediFlowPipeline.cpp
    src/agents/IntakeAgent.cpp
    src/agents/ExtractionAgent.cpp
    src/agents/ValidationAgent.cpp
    src/agents/VerificationAgent.cpp
    src/core/AgentManager.cpp
    src/models/Patient.cpp
    src/llm/LLMClient.cpp
)

target_include_directories(
    MediFlow
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

find_package(CURL REQUIRED)

target_link_libraries(
    MediFlow
    PRIVATE
    nlohmann_json::nlohmann_json
    CURL::libcurl
)