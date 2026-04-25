# Software Requirements Specification (SRS)
## Project Name: Tandrusti
**Version:** 1.0  
**Date:** March 28, 2026  
**Prepared For:** Omer Tariq (Salahuddin University - Erbil)  
**Prepared By:**  
- Aram Asaad (Project Manager)  
- Ameen Abubakr (UI/UX Designer)  
- Bashar Bahjat (Frontend Developer)  
- Mustafa Muhamad (Backend Developer)  
- Rami Ahmed (QA Engineer)  

---

## 1. Introduction

### 1.1 Purpose
The purpose of this document is to outline the software requirements for the "Tandrusti" mobile application. It aims to act as a definitive guide for the development, design, and QA testing teams, providing a comprehensive understanding of the system's architecture, features, and constraints.

### 1.2 Document Conventions
- **Must/Shall**: Indicates a mandatory requirement.
- **Should**: Indicates a highly desirable, though optional, feature.
- **May**: Indicates an optional feature.

### 1.3 Intended Audience
This document is intended for:
- The Development Team (Frontend & Backend)
- The UI/UX Designer
- QA Engineers
- Project Stakeholders (Academic Supervisors, Instructors)

### 1.4 Project Scope
**Tandrusti** is a comprehensive healthcare platform designed to solve the chaos of finding verified clinic locations in Kurdistan. Rather than relying on unstructured social media interactions, patients will use Tandrusti to find verified doctor locations mapped via Google Maps. Additionally, the app provides an educational Lab & Diagnostics Guide, a scientific medicine repository, and a pill reminder system to function as a holistic health hub for patients, students, and elderly users.

_Out of Scope:_ Online booking/scheduling, direct pharmaceutical sales, and telehealth consultations.

---

## 2. Overall Description

### 2.1 Product Perspective
Tandrusti is a standalone cross-platform mobile application built using the Flutter framework. It will utilize Google Firebase as its backend for data storage (Cloud Firestore), user authentication (if required), and remote content management (Firebase Remote Config).

### 2.2 Product Functions
The application will provide the following primary functions:
- **Doctor Directory Engine**: Listing and searching of doctors with specific specialties.
- **Geographic Navigation**: Redirection to Google Maps to route users directly to clinics.
- **Medical Test Guide**: Informational modules explaining preparation for labs/scans.
- **Medicine Encyclopedia**: Database of pharmaceutical drugs queried by scientific name.
- **Medication Adherence**: A centralized pill reminder system via push notifications.

### 2.3 User Classes and Characteristics
1. **General Patients**: Require an intuitive UI, quick access to navigation, and readable text for test preparations.
2. **Elderly Patients**: Require high accessibility (clear contrast, large text), native language support (Kurdish), and functional local notifications for pill reminders.
3. **Medical & Pharmacy Students**: Require high data accuracy within the medical test and drug encyclopedia sections, along with efficient search capabilities.

### 2.4 Operating Environment
- **Operating Systems**: Android 8.0+ and iOS 12.0+
- **Hardware**: Standard modern smartphones.
- **Dependencies**: Requires internet access to fetch directory updates. The device must possess a native maps application (e.g., Google Maps) to manage routing.

### 2.5 Assumptions and Dependencies
- Users have Google Maps (or equivalent) installed for directory navigation to function.
- Medical, pharmaceutical, and locational data is pre-validated by the administration and accurately populated into Firebase.

---

## 3. System Features

### 3.1 Doctor Directory & Advanced Search
- **Description**: A comprehensive listing of verified doctors in Kurdistan.
- **Requirements**:
  - The system shall allow users to search for doctors by name, specialty, or location.
  - The system shall display verified "Sitting Places" (clinic locations).
  - The system must provide a "Get Directions" button that invokes a URI scheme to open the native maps application with the target coordinates.
  - **User Story**: "As a patient, I want to click 'Get Directions', so that Google Maps opens and navigates me to the clinic."

### 3.2 Scientific Medicine Encyclopedia
- **Description**: A database containing scientific descriptions, indications, and side effects of drugs.
- **Requirements**:
  - The system shall list drugs strictly by their scientific names to maintain academic and medical neutrality.
  - The system shall implement an efficient remote or local text search on the drug index.
  - **User Story**: "As a student, I want to search drugs by scientific name, so that I can study side effects."

### 3.3 Medical Test & Diagnostics Guide
- **Description**: Educational reading material providing context for medical procedures (e.g., blood tests, MRI, CT scans).
- **Requirements**:
  - The system must present preparation guidelines (e.g., fasting hours) clearly for the selected test.
  - **User Story**: "As a user, I want to read about MRI preparation, so that I know what to do before the test."

### 3.4 Pill Reminder System
- **Description**: A scheduled notification module assisting patients with medication adherence.
- **Requirements**:
  - The system shall allow users to input a medication name, dosage frequency, and time.
  - The system must trigger a local push notification on the user's device at the scheduled time.
  - **User Story**: "As a chronic patient, I want to set pill reminders, so that I never miss a dose."

### 3.5 Personalization & Localization
- **Description**: User preference toggles for language, themes, and fast access points.
- **Requirements**:
  - **Language**: The system must offer an instantaneous toggle between English and Kurdish viewing modes.
  - **Themes**: The system shall support both Dark and Light UI modes, adhering to the device's system preference or allowing a manual override.
  - **Favorites**: The system shall allow users to 'star' or pin specific doctors to a local "My Doctors" list.

---

## 4. Nonfunctional Requirements

### 4.1 Performance Requirements
- Search queries for doctors and medicines must load and display results within 1.5 seconds under standard 4G network conditions.

### 4.2 Reliability & Availability
- The application aims for a 99% crash-free session rate as measured by Firebase Crashlytics.
- The Pill Reminder system must trigger accurately regardless of the device's doze/sleep state, requiring platform-specific background execution strategies.

### 4.3 Security Requirements
- The application will utilize Firebase's security rules to ensure the main directory database is strictly read-only for public clients.
- The application must not expose any sensitive PII (Personally Identifiable Information) beyond voluntary local data inputs (like pill schedules).

### 4.4 Usability Constraints
- The UI/UX must comply with high readability and accessibility standards, using distinguishable contrast ratios catering significantly to visually impaired or elderly users.

---

## 5. System Architecture & Tech Stack

- **Frontend Application**: Flutter (Dart) - Chosen for fast cross-platform deployment.
- **Backend / Database**: Google Firebase Cloud Firestore - Scalable NoSQL real-time document database.
- **Dynamic Configuration**: Firebase Remote Config - Allows updating variables and feature toggles without deploying a new app version.
- **External Integrations**: `url_launcher` package for Google Maps intent handling.
- **UI Design / Prototyping**: Figma
- **Project Management**: Agile via Trello

---

## 6. Implementation Timeline (Agile Sprints)

- **Sprint 1 – Foundation (Weeks 1–2):** 
  - UI/UX wireframes and Figma prototyping.
  - Flutter & Firebase project initialization.
  - Implementation of the basic Doctor Directory structure.
- **Sprint 2 – Core Features (Weeks 3–6):** 
  - Development of the Medicine Encyclopedia and Medical Test Guide.
  - Doctor details screen implementation.
  - Google Maps (`url_launcher`) integration.
- **Sprint 3 – Advanced Features (Weeks 7–8):** 
  - Implementation of the Pill Reminder system leveraging local native push notifications.
  - Development of the English/Kurdish Language toggle and Dark/Light UI modes.
- **Sprint 4 – Testing & Finalization (Weeks 9–12):** 
  - Quality Assurance testing on physical devices.
  - Defect tracking and bug resolution.
  - Performance profiling.
  - Project documentation and final university submission prep.

---

## 7. Appendices

### Appendix A: Future Enhancements (Post-V1.0 Roadmap)
- **Daily Health Journal:** A subjective logging feature allowing patients to track notes on pain levels and symptom progression.
- **Live Pharmacy Map:** A localized map integration displaying real-time open pharmacies nearby.

### Appendix B: Risk Matrix

| Identified Risk | Probability | Impact | Proposed Mitigation Strategy |
| :--- | :--- | :--- | :--- |
| **Outdated Clinic Locations** | High | High | Incorporate a contextual "Report Error" feature inside doctor profiles, allowing users to asynchronously flag incorrect data for manual administrative review. |
| **Notifications Failing on Android** | Medium | High | Android OEM wrappers (Samsung, Xiaomi) aggressively kill background processes. The QA team must rigorously test the notification channels using multiple vendor devices. Ensure `exact_alarms` permissions are correctly requested. |
