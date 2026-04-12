# Resume Analyser 📄🚀

A premium, full-stack AI application designed to analyze resumes against target job roles, providing ATS (Applicant Tracking System) scores, professional summaries, key strengths, critical weaknesses, and actionable improvement suggestions.

---

## 🌟 Project Overview
**Resume Analyser** is a high-performance SaaS application that bridges the gap between candidates and recruiters. By leveraging AI, the app provides a clinical deep-dive into how a resume stacks up against specific industry roles, allowing users to iterate and improve their professional branding before applying.

### **✨ Key Features:**
*   **ATS Scoring Engine**: Real-time analysis providing a weighted score (0-100) based on role-specific requirements.
*   **Deep Insight Analysis**: Classified feedback across **Professional Summary**, **Strengths**, **Weaknesses**, and **Actionable Steps**.
*   **Persistent Career Goals**: Set your **Target Role** and **Experience Level** once; the app persists these goals across sessions and uses them for every analysis.
*   **Ultra-Fast Theme Engine**: Experience sub-millisecond (0.2ms) synchronized theme transitions between Light and Dark modes.
*   **Branded Experience**: Featuring custom Gemini-generated logos and a unified professional aesthetic.
*   **Secure History**: Track your progress with a locally-synced analysis history.

### **🛠 Tech Stack:**
*   **Frontend**: Flutter (State Management via `Provider`, Persistence via `SharedPreferences`).
*   **Backend**: Node.js & Express.js.
*   **Data Store**: MongoDB (Primary) with a robust `mock_db.json` fallback for offline/local development.
*   **Infrastructure**: Docker & Docker Compose support for containerized deployment.

---

## 🔄 Project Workflow
The user journey in **Resume Analyser** is designed for maximum efficiency and professional growth:

1.  **Identity Management**: User authenticates via JWT-secured Login/Signup.
2.  **Goal Setting**: The user enters their **Target Role** and **Experience Level** (e.g., "Full Stack Developer", "Mid Level"). These are stored in the user profile.
3.  **Resume Ingestion**: User taps the upload zone to select their latest PDF resume.
4.  **AI Orchestration**:
    *   The backend extracts PDF text.
    *   Metadata (Current Role/Experience) is bundled with the resume content.
    *   AI processes the bundle against the target role's requirements.
5.  **Diagnostic Feedback**: The app renders a clean dashboard with the ATS score and detailed breakdown cards.
6.  **Persistence**: The analysis is saved to the user's history for long-term tracking.

---

## 🚀 Developer Setup (How to Run)

### **Option 1: Manual Startup**

#### **Step A: The Backend**
1.  Navigate to `/backend`.
2.  Install dependencies: `npm install`.
3.  Verify `.env` file exists (contains your API keys and Port config).
4.  Start: `npm start`.
    *   *Check: Look for "Server running on port 5000".*

#### **Step B: The Frontend**
1.  Navigate to `/ai_resume_analyzer`.
2.  Fetch packages: `flutter pub get`.
3.  Launch: `flutter run`.

### **Option 2: Docker Setup**
Run the entire backend ecosystem with a single command:
```bash
docker-compose up --build
```

---

## 📱 Mobile Deployment (Physical Device)

Testing on a real phone requires the app to communicate with your computer over your local Wi-Fi.

### **1. Configure Network Bridge**
1.  On your computer, find your Local IP (IPv4):
    *   **Windows**: Run `ipconfig` in Command Prompt.
    *   **Mac/Linux**: Run `ifconfig` or `ip a`.
2.  Note the address (e.g., `192.168.1.5`).

### **2. Update Connection Point**
Open `ai_resume_analyzer/lib/utils/constants.dart` and update the `baseUrl`:
```dart
static const String baseUrl = 'http://YOUR_IP_ADDRESS:5000';
```

### **3. Launch & Test**
1.  Enable **USB Debugging** on your phone.
2.  Connect your phone to your computer.
3.  Inside `/ai_resume_analyzer`, run:
    ```bash
    flutter run -d <YOUR_DEVICE_ID>
    ```

---

## 📁 Project Structure
```text
/
├── ai_resume_analyzer/    # Flutter Mobile Application
│   ├── assets/            # Branded Logos & UI Assets
│   ├── lib/
│   │   ├── core/          # Themes & Design Tokens
│   │   ├── providers/     # State Management (Auth, Resume, Theme)
│   │   ├── screens/       # UI Screens (Dashboard, Profile, History)
│   │   └── services/      # API Clients & Auth Logic
├── backend/               # Node.js API Server
│   ├── models/            # Database Schemas
│   ├── routes/            # API Endpoints (Auth, Analysis, Profile)
│   └── mock_db.json       # Local Data Persistence Fallback
└── docker-compose.yml     # Container Orchestration
```

---

## 📄 License
This project is for demonstration and SaaS development purposes. All rights reserved.
