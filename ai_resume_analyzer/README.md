# Resume Analyser - Frontend (Flutter) 📱

This is the Flutter-based frontend for the **Resume Analyser** project. It is designed with a premium, mobile-first aesthetic and features advanced state management and theme synchronization.

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (stable channel)
- Android Studio / Xcode (for mobile deployment)
- VS Code (recommended with Flutter/Dart extensions)

### **Setup**
1.  Navigate to this directory:
    ```bash
    cd ai_resume_analyzer
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  **Configure API Endpoint**:
    Open `lib/utils/constants.dart` and ensure `baseUrl` points to your running backend server (use your local IP for physical device testing).

4.  **Launch**:
    ```bash
    flutter run
    ```

## 🛠 Project Specifics

### **State Management**
The app uses the `Provider` package to manage three main pillars:
- `AuthProvider`: Manages user sessions, profile persistence, and JWT tokens.
- `ResumeProvider`: Handles PDF uploads, AI analysis orchestration, and history tracking.
- `ThemeProvider`: Controls the global dark/light state with high-speed animation hooks.

### **Asset Branding**
Launcher icons are managed via `flutter_launcher_icons`. If you wish to rotate the branding:
1. Replace `assets/images/app_logo.png`.
2. Run:
   ```bash
   dart run flutter_launcher_icons
   ```

## 📂 Architecture
- `lib/core/`: Contains the `AppTheme` design system.
- `lib/providers/`: Business logic and global state.
- `lib/screens/`: UI layer separated into functional tabs (Home, Analysis, History, Profile).
- `lib/services/`: Specialized API clients for Resume analysis and Auth.
- `lib/widgets/`: Highly reusable UI components (Dialogs, Cards, Inputs).

---
For full project setup instructions (including Backend and Docker), please refer to the [Root README](../README.md).
