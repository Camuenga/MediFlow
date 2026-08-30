#include "agents/VerificationAgent.hpp"
#include <nlohmann/json.hpp>
#include <iostream>

using json = nlohmann::json;

std::string VerificationAgent::process(
    const std::string& input)
{
    std::cout << "\n[Verification Agent]\n";

    json patient = json::parse(input);
    bool valid = true;

    if(!patient.contains("validation")){

        std::cout << "Validation result missing. \n";
        valid = false;
    }else{

        valid = patient["validation"]["valid"];
    }

    std::cout << (valid ? "Verification: Passed \n" : "Verification: FAILED \n");
  

    patient["verification"] = {
        {"approved",valid}
    };

    return patient.dump(4);
}