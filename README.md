# AI Resume Analyzer 📄🚀

A premium, full-stack AI application designed to analyze resumes against target job roles, providing ATS (Applicant Tracking System) scores, professional summaries, key strengths, critical weaknesses, and actionable improvement suggestions.

---

## 🌟 Project Overview
The **AI Resume Analyzer** is a premium, full-stack SaaS application designed to help job seekers optimize their resumes. It uses AI to bridge the gap between a candidate's resume and their target job description.

### **Key Features:**
*   **ATS Scoring Engine**: Calculates a real-time "Applicant Tracking System" score (0-100) based on how well the resume matches the target job role.
*   **Intelligent Feedback**: Provides a structured breakdown into **Professional Summary**, **Key Strengths**, **Critical Weaknesses**, and **Improvement Suggestions**.
*   **Adaptive Theme Engine**: Features a global Dark/Light mode toggle with ultra-high-speed (0.2ms) synchronized animations for a premium feel.
*   **History Tracking**: Saves previous analyses locally so users can track their resume improvements over time.
*   **Modern UI/UX**: Built with a "Mobile-First" design philosophy using modern typography and glassmorphism elements.

### **Tech Stack:**
*   **Frontend**: Flutter (utilizing `Provider` for state management and `SharedPreferences` for persistence).
*   **Backend**: Node.js & Express.js (handling API requests and AI logic).
*   **Data Layer**: MongoDB (primary) with a built-in `mock_db.json` fallback for offline development.

---

## 🚀 How to Run the Project (Developer Setup)

To get the entire system running, you must start both the **Backend Server** (to handle the logic) and the **Frontend App** (to see the UI).

### **Step A: Start the Backend (The Brains)**
1.  Open a terminal and navigate to the `backend` folder:
    ```bash
    cd backend
    ```
2.  Install the required Node.js packages:
    ```bash
    npm install
    ```
3.  Start the server:
    ```bash
    npm start
    ```
    *   **Success Check**: You should see "Server running on port 5000" in your terminal.

### **Step B: Setup the Frontend (The Interface)**
1.  Open a **new** terminal window and navigate to the `ai_resume_analyzer` folder:
    ```bash
    cd ai_resume_analyzer
    ```
2.  Fetch the Flutter dependencies:
    ```bash
    flutter pub get
    ```

---

## 📱 How to Use the Project on a Mobile Device

Running a full-stack app on a physical phone requires a "Local Network Bridge" so your phone can talk to the server running on your computer.

### **Step 1: Find your Computer's Local IP**
Your phone doesn't know what "localhost" is, so you must use your computer's actual network ID.
1.  On your computer, open a Command Prompt and type:
    ```bash
    ipconfig
    ```
2.  Look for the **IPv4 Address** (it usually looks like `192.168.X.XX`).

### **Step 2: Update the App's Connection Pointer**
1.  In VS Code, open the file: `ai_resume_analyzer/lib/utils/constants.dart`.
2.  Update the `baseUrl` with the IP you found:
    ```dart
    static const String baseUrl = 'http://YOUR_IP_HERE:5000';
    ```

### **Step 3: Connect and Launch**
1.  Connect your phone via USB with **USB Debugging** enabled.
2.  In your terminal (inside the `ai_resume_analyzer` folder), run:
    ```bash
    flutter run
    ```
3.  Select your physical device from the list when prompted.

---

## 🧭 Navigating the App
1.  **Welcome**: Start with Login/Signup to enable history tracking.
2.  **Job Selection**: Choose or type a target job role.
3.  **Upload**: Tap the upload zone to select a PDF resume.
4.  **Results**: Review your ATS score and breakdown. Use "Strengths" and "Weaknesses" for quick insights.
5.  **Preferences**: Go to the **Profile** tab -> **Preferences** to experience the frame-perfect 0.2ms theme transition.

---

## 🧼 Maintenance
To remove diagnostic logs:
```bash
Remove-Item -Path ai_resume_analyzer/errors.txt, ai_resume_analyzer/flutter_analyze.txt -Force
```

## 📄 License
This project is for demonstration and educational purposes.
