# Tandrusti Mobile Application - Project Description and Architecture

## 1. Project Overview
**Tandrusti** is a comprehensive, cross-platform healthcare mobile application built using the Flutter framework. The primary goal of the project is to provide a structured and verified solution for finding clinic locations in Kurdistan, addressing the current reliance on unverified social media information. Beyond acting as a directory, Tandrusti serves as a holistic health hub designed for general patients, elderly users, and medical students. 

The project was planned and developed using Agile (Scrum) methodologies, with the development cycle divided into structured sprints to ensure continuous integration of feedback. UI/UX design was prioritized using Figma to create high-fidelity mockups following Material Design best practices, ensuring high accessibility (large text, high contrast) specifically catering to elderly users.

## 2. Core Features
The application is structured to deliver several critical healthcare functionalities:
*   **Doctor Directory Engine:** A categorized list of verified doctors that users can search by name, specialty, or location.
*   **Geographic Navigation:** Direct integration with native maps (e.g., Google Maps) via URI schemes to provide exact routing to clinics.
*   **Scientific Medicine Encyclopedia:** A searchable database of pharmaceutical drugs organized by scientific names, detailing indications and side effects.
*   **Medical Test & Diagnostics Guide:** Educational modules explaining how patients should prepare for various medical procedures (e.g., fasting before blood tests or MRI scans).
*   **Pill Reminder System:** A personalized schedule that triggers local device push notifications to help patients adhere to their medication routines.
*   **Personalization & Localization:** Dynamic toggling between Kurdish and English languages, and support for Dark and Light themes.

## 3. App Flow and Advanced Navigation
The application employs advanced navigation patterns to ensure a smooth user journey:
*   **Splash & Onboarding Screens:** A splash screen covers the initial cold start, followed by an onboarding flow that introduces first-time users to the app's core value propositions.
*   **Authentication Flow:** A secure entry point requiring users to register and log in. It utilizes Firebase Authentication, including email verification and password reset capabilities.
*   **Primary Navigation:** Once authenticated, users land on the Home Screen. The app utilizes **Bottom Tab Navigation** for quick access to primary sections (Home, Directory, Reminders, Settings) and **Stack Navigation** for deep-linking into specific doctor or medicine detail screens.

## 4. Software Architecture: Model-View-Controller (MVC)
To ensure the project remains scalable, maintainable, and easy to debug, the codebase follows the **Model-View-Controller (MVC)** architectural pattern. This separation of concerns divides the application into three interconnected components:

### 4.1. Model (Data & Business Logic)
The Model layer represents the data structure and the rules that govern data access and updates. In Tandrusti, this layer acts as the bridge between the app and the backend database (Google Firebase Cloud Firestore).
*   **Responsibilities:** Defining data structures (e.g., `Doctor`, `Medicine`, `Test`, `User`), fetching data from Firestore, and processing local data for the pill reminder system.
*   **Implementation:** Dart classes that parse JSON data from Firebase into structured objects. This layer remains entirely independent of the user interface.

### 4.2. View (UI Widgets)
The View layer is what the user sees and interacts with. In Flutter, this is constructed using a declarative UI approach with a widget tree.
*   **Responsibilities:** Rendering the visual elements on the screen, capturing user inputs (taps, text entry), and displaying data provided by the Controller.
*   **Implementation:** The `lib/screens/` and `lib/widgets/` directories. This includes the `LoginScreen`, `HomeScreen`, `DoctorDetailScreen`, and reusable components like custom buttons and input fields. The View does not fetch data directly from Firebase; it simply listens to the Controller.

### 4.3. Controller (State & Logic Management)
The Controller layer acts as the middleman between the Model and the View. It responds to user interactions from the View, updates the Model, and manages the application's state.
*   **Responsibilities:** Handling authentication logic, processing search queries, managing language and theme states, and pushing local notifications.
*   **Implementation:** The `lib/services/` directory. Services like `AuthService` handle login/signup requests to Firebase, while `AppState` manages the current theme and language settings. When the Controller retrieves new data from the Model, it triggers a state update (e.g., using `setState` or state management providers), which commands the View to rebuild and display the latest information.

## 5. Backend Integration
The project relies heavily on **Google Firebase**:
*   **Firebase Authentication:** Used for secure user sign-up, login, and managing user sessions.
*   **Cloud Firestore:** A NoSQL real-time database used to store and retrieve the doctor directory, medicine encyclopedia, and test guides dynamically without requiring app updates.

By adhering to the MVC architecture, Tandrusti maintains a clean separation between the database interactions, the app logic, and the user interface, resulting in a robust and professional mobile application.
