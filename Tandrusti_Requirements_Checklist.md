# Tandrusti Mini-Project: Requirements & Compliance Checklist

Based on the `Mobile_application_flutter_mini_project.html` guidelines, your mini-project makes up 20-25% of your final grade. To ensure you get maximum marks, I have evaluated the **Tandrusti Project** against the strict requirements and identified exactly what is completed and what is still needed.

## 1. Required Features (Implementation Status)

Here is how Tandrusti stacks up against the mandatory features:

 (Completed) The app uses the MVC pattern with a clear separation of `screens`, `widgets`, `services`, and `models`.
- [x] **UI/UX Best Practices:** (Completed) The app uses Material Design, high-contrast layouts for the elderly, and proper navigation flows.
- [x] **Authentication System:** (Completed) Built with Firebase Auth, supporting registration, login, and email verification.
- [x] **Database Integration:** (Completed) Utilizing Firebase Cloud Firestore for NoSQL data management (Doctors, Medicines, Tests).
- [x] **Backend System:** (Completed) Handled via Firebase Services.
- [x] **Search and Filtering:** (Completed) Implemented for finding specific doctors and searching the medical encyclopedia.
- [x] **Dark Mode:** (Completed) The app supports both Light and Dark themes.
- [x] **Admin Panel (Optional but included):** (Completed) You have the `tandrusti_admin_web` dashboard.
- [!] **Push Notifications:** (Needs Attention) You have *local* notifications for the Pill Reminder. However, the rubric specifically asks for **Firebase Cloud Messaging (FCM)**. You may need to add remote push notifications (e.g., an admin sending a broadcast message about a new clinic).
- [!] **API Integration:** (Needs Attention) The rubric asks to "Consume RESTful APIs or GraphQL". Firebase uses its own SDK. To be safe, you might want to integrate a simple public REST API (e.g., fetching a "Health Quote of the Day" using the `http` package).
- [ ] **Image Upload & Management:** (Missing) You need to allow users to upload profile pictures or allow admins to upload clinic/doctor images to Firebase Storage. 
- [ ] **Reviews and Ratings:** (Missing) The rubric strictly requires a rating mechanism (stars) and review submission. You should add a feature where users can leave a 1-5 star review and a comment on a Doctor's profile.

---

## 2. Final Deliverables Breakdown

To complete the project for the **April 1, 2026** deadline, you must submit three main things:

### A. Full Implementation
- Source code pushed to GitHub (Already done!).
- Working app on a device/emulator.

### B. Professional Documentation / Final Report
Your final report must include specific sections. You can use this as your template:
1. **Executive Summary:** A brief overview of Tandrusti.
2. **System Architecture & Design:** Explanation of your MVC approach.
3. **Database Schema & Models:** A breakdown of your Firestore collections (`users`, `doctors`, `medicines`, `tests`, `reviews`).
4. **API Documentation:** Details on Firebase usage and any REST API integrations.
5. **User Manual/Guide:** Instructions on how to use the app.
6. **Testing Documentation:** Test cases for Auth, Pill Reminders, and Search.
7. **Agile Methodology Details:** How you used Sprints, Standups, and Backlogs in Trello.
8. **Challenges Faced & Solutions:** E.g., dealing with Android notification permissions for the Pill Reminder.
9. **Team Member Contributions:** 
   - **Aram Asaad**: Project Manager
   - **Ameen Abubakr**: UI/UX Designer
   - **Bashar Bahjat**: Frontend Developer
   - **Mustafa Muhamad**: Backend Developer
   - **Rami Ahmed**: QA Engineer

### C. Final Presentation
You will need a PowerPoint presentation covering:
- Objectives and target audience.
- Live demonstration of Tandrusti.
- Explanation of MVC and Firebase.
- How your team used Agile (Sprints).
- Q&A Preparation.

---

## Action Plan Recommendations:
1. **Add Reviews & Ratings:** Create a new Firestore collection called `reviews` and add a UI on the `DoctorDetailScreen` to submit a 1-5 star rating.
2. **Add Image Uploads:** Add a feature in `edit_profile_screen.dart` allowing users to upload a profile picture using `image_picker` and `firebase_storage`.
3. **Integrate a basic REST API:** Add a simple API call using the `http` package to fully satisfy the "API Integration" requirement.
4. **Draft the Final Document:** Start filling out the structure provided in Section B above.
