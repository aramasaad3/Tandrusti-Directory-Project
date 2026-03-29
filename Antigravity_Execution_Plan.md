# Antigravity Implementation Plan
## Project Name: Tandrusti
**Building Everything Here (No External Tools)**

This plan outlines how we will construct the entire Tandrusti application step-by-step directly within this environment. We are skipping Figma and external management tools; we will write the code, build the UI, setup the database, and test the features right here.

---

### Phase 1: Project Initialization & Scaffold (What we do first)
- **Action**: I will run the Flutter CLI tools in the terminal to generate the base application.
- **Action**: Clean up the default counter app and establish our folder structure (`lib/screens`, `lib/models`, `lib/services`, `lib/widgets`).
- **Action**: Initialize Firebase using the `flutterfire_cli` to hook up the Android and iOS platforms to your backend.
- **Outcome**: A clean, compiling Flutter app connected to Firebase.

### Phase 2: Data Models & Mock Repositories
- **Action**: Define the Dart classes (`Doctor`, `Medicine`, `MedicalTest`, `Reminder`).
- **Action**: Create JSON "Mock Data". Before we pull real data from Firestore, we will hardcode 5-10 doctors and medicines so we can build and see the UI immediately without depending on an active internet connection.
- **Outcome**: The data structure is prepared and ready to feed the user interface.

### Phase 3: Core UI & App Shell Construction
- **Action**: Build the `MainScreen` with a Bottom Navigation Bar (Tabs: Directory, Encyclopedia, Reminders, Settings).
- **Action**: Implement the premium aesthetic directly in Flutter (colors, typography, rounded cards, shadows).
- **Action**: Build the Theme system (Dark Mode / Light Mode toggle) and the skeleton for Kurdish/English translations.
- **Outcome**: The app "shell" is fully navigable, looks beautiful, and responds to theme changes.

### Phase 4: Feature Implementation - Directory & Medicine
- **Action**: Build the **Doctor Directory Screen**. Add a search bar, filter chips for specialties, and a list of visually appealing doctor cards.
- **Action**: Integrate the `url_launcher` package. When a user clicks "Get Directions" on a doctor card, we write the logic to open their local maps app.
- **Action**: Build the **Scientific Medicine Encyclopedia** and **Medical Test Guide** screens with searchable lists and detailed reading views.
- **Outcome**: The core informational features of the app are fully functional.

### Phase 5: Advanced Features - Reminders & Favorites
- **Action**: Implement local push notifications using `flutter_local_notifications` for the **Pill Reminder System**.
- **Action**: Build the UI for a user to schedule a new medication reminder (Time pickers, frequency selection).
- **Action**: Implement local storage (`shared_preferences`) so users can save certain doctors to a "Favorites" list.
- **Outcome**: The complex, state-driven user features are active.

### Phase 6: Polish, Testing, & Final Handoff
- **Action**: Review the UI for premium aesthetics. We adjust paddings, fix text styles, and ensure animations feel smooth.
- **Action**: Verify the Firebase connections and ensure everything runs smoothly without crashing on the local machine/emulator.
- **Action**: Provide you with the final compiling code ready to be exported, presented for your university project, or built into a final APK.

---

### What to do NEXT?
Since you requested no code yet, our immediate next step to begin execution is to transition into **Phase 1**. 

When you are ready, simply tell me to "**Start Phase 1**", and I will execute the terminal commands to create the Flutter project bundle, set up the folders, and prep the environment for our first line of code!
