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
    src/agents/RoutingAgent.cpp
    
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

# ========================================
# TESTS
# ========================================

add_executable(ValidationTests

    tests/ValidationTests.cpp

    src/agents/ValidationAgent.cpp
)

target_include_directories(
    ValidationTests
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(
    ValidationTests
    PRIVATE
        nlohmann_json::nlohmann_json
)

# ========================================
# ROUTING TESTS
# ========================================

add_executable(RoutingTests

    tests/RoutingTests.cpp

    src/agents/RoutingAgent.cpp
)

target_include_directories(
    RoutingTests
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(
    RoutingTests
    PRIVATE
        nlohmann_json::nlohmann_json
)
# ========================================
# VERIFICATION TESTS
# ========================================

add_executable(VerificationTests

    tests/VerificationTests.cpp

    src/agents/VerificationAgent.cpp
)

target_include_directories(
    VerificationTests
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(
    VerificationTests
    PRIVATE
        nlohmann_json::nlohmann_json
)
# ========================================
# PATIENT TESTS
# ========================================

add_executable(PatientTests

    tests/PatientTests.cpp
    src/models/Patient.cpp
)
enable_testing()

add_test(NAME PatientTests COMMAND PatientTests)
add_test(NAME ValidationTests COMMAND ValidationTests)
add_test(NAME RoutingTests COMMAND RoutingTests)
add_test(NAME VerificationTests COMMAND VerificationTests)
add_test(NAME PipelineTests COMMAND PipelineTests)

target_include_directories(
    PatientTests
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(
    PatientTests
    PRIVATE
        nlohmann_json::nlohmann_json
)
# ========================================
# PIPELINE TESTS
# ========================================

add_executable(PipelineTests

    tests/PipelineTests.cpp

    src/agents/ValidationAgent.cpp
    src/agents/RoutingAgent.cpp
    src/agents/VerificationAgent.cpp
)

target_include_directories(
    PipelineTests
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)

target_link_libraries(
    PipelineTests
    PRIVATE
        nlohmann_json::nlohmann_json
)