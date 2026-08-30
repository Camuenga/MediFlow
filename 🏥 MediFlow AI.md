# 🏥 MediFlow AI

**AI-powered administrative patient intake and verification system.**

MediFlow AI automates the initial collection, extraction, validation, and verification of patient information, helping healthcare staff reduce repetitive administrative work.

> **MediFlow AI does not diagnose patients. It supports administrative healthcare workflows.**

---

## 🚨 Problem

Healthcare reception staff spend significant time collecting and registering repetitive patient information.

For example:

```text
50 patients × 8 minutes = 400 minutes
400 minutes ÷ 60 = 6h 40min
```

**50 patients can represent approximately 6 hours and 40 minutes of administrative intake work.**

---

## 💡 Solution

MediFlow AI creates an automated intake pipeline:

```text
Patient
   ↓
Intake Agent
   ↓
Extraction Agent
   ↓
Validation Agent
   ↓
Verification Agent
   ↓
Healthcare Staff
```

The system converts patient conversations into structured and verified information.

---

## 🤖 AI Agents

| Agent | Responsibility |
|---|---|
| Intake | Collect patient information |
| Extraction | Convert conversation → JSON |
| Validation | Check required fields |
| Document | Document/OCR processing *(future)* |
| Routing | Administrative routing *(future)* |
| Verification | Verify extracted information |

---

## 💻 Technology

### Current

- C++
- CMake
- libcurl
- nlohmann/json
- LLM API
- MinGW / MSYS2

### Planned

- REST API
- Database
- Web Frontend
- OCR
- Document Processing
- Cloud Deployment

---

## 🏗️ Project Structure

```text
mediflow/
├── src/
│   ├── agents/
│   ├── core/
│   ├── models/
│   └── llm/
├── tests/
├── data/
├── CMakeLists.txt
└── README.md
```

---

## ⚙️ Build

### Requirements

- CMake
- MinGW/MSYS2
- C++17 or newer
- LLM API key

### Configure

```cmd
mkdir build
cd build

cmake .. -G "MinGW Makefiles" ^
-DCMAKE_C_COMPILER=C:/msys64/mingw64/bin/gcc.exe ^
-DCMAKE_CXX_COMPILER=C:/msys64/mingw64/bin/g++.exe ^
-DCMAKE_PREFIX_PATH=C:/msys64/mingw64 ^
-DOPENSSL_ROOT_DIR=C:/msys64/mingw64
```

### Build

```cmd
cmake --build .
```

### Run

```cmd
MediFlow.exe
```

---

## 🔐 API Key

Set the API key as an environment variable.

Windows CMD:

```cmd
set GROQ_API_KEY=YOUR_API_KEY
```

PowerShell:

```powershell
$env:GROQ_API_KEY="YOUR_API_KEY"
```

**Never commit API keys to GitHub.**

---

## 🎬 MVP Demo

Example:

```text
================================
          MEDIFLOW AI
================================

Patient verified successfully

Name: João Manuel
Age: 35
Reason: headache
Duration: three days
Phone: 923000000

Status: APPROVED

================================
```

---

## 🚧 MVP Limitations

Due to the limited hackathon development time, the current MVP focuses on the core AI pipeline.

The following components are planned for future development:

- Frontend
- Database
- REST API
- OCR
- Document Agent
- Routing Agent
- Production deployment

---

## 🚀 Vision

MediFlow AI aims to reduce administrative workload so healthcare staff can spend more time focused on **patients rather than repetitive data collection**.

> **Collect → Structure → Validate → Verify → Assist**

---

## 📄 Documentation

Detailed project documentation is available in the project documentation folder.

**MediFlow AI — AI-powered administrative patient intake.**