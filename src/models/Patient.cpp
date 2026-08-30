#include "models/Patient.hpp"
#include <nlohmann/json.hpp>

using json = nlohmann::json;

std::string patientToJson(const Patient& patient){
	
	json data;

	data["name"] = patient.name;
	data["age"] = patient.age;
	data["reason"] = patient.reason;
	data["duration"] = patient.duration;
	data["documents"] = patient.documents;
	data["phone"] = patient.phone;

	return data.dump(4);
}

Patient patientFromJson(const std::string& input){
	
	const json data = json::parse(input);

	Patient patient; 

	if(data.contains("name") && data["name"].is_string()){
		patient.name = data["name"].get<std::string>();
	}

	if(data.contains("age") && data["age"].is_number_integer()){
		patient.age = data["age"];
	}

	if(data.contains("reason") && data["reason"].is_string()){
		patient.reason = data["reason"];
	}

	if(data.contains("duration") && data["duration"].is_string()){
		patient.duration = data["duration"];
	}

	if(data.contains("documents") && data["documents"].is_array()){
		patient.documents = data["documents"].get<std::vector<std::string>>();
	}

	if(data.contains("phone") && data["phone"].is_string()){
		patient.phone = data["phone"];
	}

	return patient; // after replace witha pointer* object cannot be send like a normal variable

}