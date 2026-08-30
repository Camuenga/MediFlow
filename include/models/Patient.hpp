#ifndef PATIENT_H
#define PATIENT_H

#include <string>
#include <vector>

struct Patient
{
    int age = 0;
    std::string name;
    std::string reason;
    std::string duration;
    std::string phone;

    std::vector<std::string> documents;

};

std::string patientToJson(const Patient& patient);
Patient patientFromJson(const std::string& json);

#endif