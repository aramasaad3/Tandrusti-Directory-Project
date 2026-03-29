# Implementation Plan
## Project Name: Tandrusti
**Phase-by-Phase Execution Guide (Start to Finish)**

This document details the step-by-step technical and operational implementation strategy for building the Tandrusti mobile application. It maps the project proposal and SRS into a tangible development roadmap.

---

## Phase 1: Project Setup & Foundation (Weeks 1-2)

### 1.1 UI/UX & Asset Finalization
- **Figma Prototyping**: Complete wireframes for all core screens (Home, Doctor List, Doctor Details, Medicine List, Test Guide, Reminders).
- **Design System Blueprinting**: Define the typography (Kurdish-supported fonts), color palettes for both Dark and Light modes, and iconography.
- **Assets Gathering**: Export logo, launch icons, and placeholder imagery.

### 1.2 Version Control & Project Management
- **Repository Setup**: Initialize a Git repository (GitHub/GitLab) with standard branches (`main`, `develop`, `feature/*`).
- **Trello Setup**: Map out the agile boards based on the 4 Sprints, assigning specific cards to Frontend (Aram Asaad), Backend (Mustafa Muhamad), and QA (Rami Ahmed).

### 1.3 Technical Environment Initialization
- **Flutter Framework Initialization**: Create the base Flutter project using consistent architecture (e.g., MVVM, Riverpod, or BLoC).
- **Firebase Initialization**:
  - Create the exact Firebase project inside the Google Cloud Console.
  - Register Android (`build.gradle`) and iOS (`Runner.xcworkspace`) apps within Firebase.
  - Download and configure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

---

## Phase 2: Backend & Database Architecture structuring (Week 3)

### 2.1 Firestore Database Modeling
Define NoSQL collections strictly (mock schema planning):
- `doctors_directory`: Fields for Name, Specialty, Clinic Location (Lat/Long), Phone Number, Work Hours.
- `medicines`: Fields for Scientific Name, Trade Names, Usage, Side Effects.
- `medical_tests`: Fields for Test Name, Purpose, Preparation Instructions (e.g., Fasting).

### 2.2 Security & Indexing
- **Firestore Security Rules**: Set strict Read-Only rules to prevent public users from mutating directory data.
- **Indexes**: Configure composite indexes in Firebase to allow complex filtering (e.g., querying Doctors by both 'Specialty' and 'City').

### 2.3 Remote Config Pipeline
- Setup Firebase Remote Config keys for feature flags (e.g., `is_pill_reminder_enabled`) and minor dynamic content adjustments.

---

## Phase 3: Core App Shell & UI Engineering (Weeks 4-5)

### 3.1 Theming & Localization Engine
- **Localization (Kurdish/English)**: Integrate localization packages (e.g., `easy_localization`). Setup `.json` or `.arb` translation files for all static UI strings.
- **Theme Manager**: Implement a theme controller allowing dynamic switching between Light and Dark visual system based on device settings or manual toggle.

### 3.2 Navigation Structure
- **Routing Setup**: Implement a scalable routing system (like `go_router` or `auto_route`) to handle deep links and hierarchical navigation.
- **App Shell**: Build the persistent scaffold (e.g., Bottom Navigation Bar) hosting the Directory, Guides, and Settings tabs.

---

## Phase 4: Feature Development (Weeks 6-8)

### 4.1 The Doctor Directory Engine
- Build the list views fetching live paginated data from Firestore.
- Implement the local text search bar and specialty filter chips.
- Add the `url_launcher` package. Read spatial coordinates from Firestore and map an `onTap` event to construct standard `geo:lat,lng` or Google Maps web links.

### 4.2 Encyclopedias (Medicines & Lab Guides)
- Build the list interface feeding from the `medicines` collection. Implement heavy local-caching so users don't repeatedly fetch the same medication data.
- Build the purely educational accordion/expansion tile UI for Medical Lab procedures and fast-reading preparation tactics.

### 4.3 Pill Reminder Module
- Integrate `flutter_local_notifications`.
- Build the User Interface for scheduling: Medication Name input, time-picker dialogue, and frequency dropdowns.
- Register background alarming permissions native to Android (`SCHEDULE_EXACT_ALARM`) and iOS Notification Centers.

### 4.4 Favorites System
- Integrate local storage (like `shared_preferences` or `hive`) to store arrays of favorite Doctor IDs. 
- Build the "My Doctors" UI tab that visually renders these specific documents.

---

## Phase 5: QA Testing & Hardening (Weeks 9-10)

### 5.1 Static & Unit Testing
- Test business logic (like time-calculation for pill reminders).
- Execute widget tests on core UI components ensuring they render correctly across different screen constraints.

### 5.2 Ecosystem Integrations & Analytics
- Install Firebase Crashlytics & Analytics to monitor App stability on test devices.

### 5.3 Manual Quality Assurance
- **Device Fragmentation Testing**: Test the UI on varied screen sizes and densities.
- **Notification Aggressiveness Test**: Crucial verification of push notifications firing on OEM-skinned Android devices while completely locked/asleep.
- **Localization QA**: Ensure Kurdish RTL (Right-to-Left) or LTR renders dynamically without breaking the UI layout.

---

## Phase 6: Deployment & Finalization (Weeks 11-12)

### 6.1 Performance Optimization
- Run Flutter DevTools to ensure 60fps scrolling inside the Doctor Directory.
- Bundle optimizations (ProGuard mapping, iOS stripped binaries).

### 6.2 Pre-Release & Academic Deliverables
- Generate final APK/AAB and iOS IPA files.
- Aggregate all documentation (SRS, Architecture diagrams, Implementation Plan).
- Final review by Project Manager (Bashar Bahjat) and Academic Supervisor (Omer Tariq).

### 6.3 Maintenance Pipeline
- Distribute app via side-loading or test environments (TestFlight for Apple, Internal track for Google Play).
- Monitor crash reports for post-launch hotfixes.
