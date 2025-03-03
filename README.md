# 📝 Task Manager App  

A simple **Flutter task management application** that allows users to **create, edit, and manage daily tasks** with authentication, local storage, and Firebase synchronization.

---

## 🚀 Features  

### 🔐 **User Authentication**  
- ✅ Email/Password authentication using **Firebase Authentication**  
- ✅ Google Sign-In  
- ✅ Secure login/logout functionality  
- ✅ **Error handling** for incorrect credentials and authentication issues  

### ✅ **Task Management**  
- ✅ Add, edit, and delete tasks  
- ✅ Tasks include:  
  - **Title & Description**  
  - **Start Date & Due Date**  
  - **Priority Level** (Low, Medium, High)  
  - **Status** (Pending, In Progress, Completed)  
- ✅ **Subtasks** support for structured task management  
- ✅ Local storage using **SQLite** for offline access  
- ✅ **Syncing with Firebase** when the user is online  
- ✅ **Filtering & Search**:  
  - Filter tasks by **status, due date, and priority**  
  - Search tasks by **title or description**  

### 🎨 **UI & Navigation**  
- ✅ Clean and **responsive UI**  
- ✅ **Navigation system** with:  
  - Login / Registration  
  - Task List  
  - Task Details / Add / Edit  
- ✅ **Dark Mode Toggle**  
- ✅ **Drawer & Bottom Navigation** for smooth navigation  

### ⚡ **State Management**  
- ✅ **Bloc (Flutter Bloc + Cubit)** for efficient and scalable state management  
- ✅ Optimized UI updates with **minimal rebuilds**  

### ☁️ **Data Sync & Cloud Storage**  
- ✅ **Sync tasks with Firebase Firestore**  
- ✅ Offline-first functionality – tasks are saved locally and synced when online  
- ✅ Fetch tasks from **Firebase** when logging in (handles **app reinstallation**)  

### 🎯 **Extra Features**  
- ✅ **Task Filtering** (Show only completed, pending, or priority tasks)  
- ✅ **Calendar View** (Visualize tasks with due dates)  

🚨 **Upcoming Features:**  
- 🚧 **Push Notifications for Task Reminders** *(Currently not implemented but planned for future updates)*  

---

## 📂 Project Structure  
lib/
│── features/
│   ├── auth/           # Authentication (Login, Registration)
│   ├── task/           # Task-related screens & logic
│   │   ├── model/      # Task & Subtask models
│   │   ├── cubit/      # Bloc for task management
│   │   ├── repo/       # Local DB & Firebase repo
│   │   ├── ui/         # Task UI components
│   ├── profile/        # User profile & settings
│── utils/              # Utility functions & global configurations
│── main.dart           # Entry point of the app

---

## 🛠️ Installation & Setup  

### 1️⃣ **Clone the Repository**  
```bash
git clone https://github.com/your-username/task-manager.git
cd task-manager

2️⃣ Install Dependencies
flutter pub get

3️⃣ Set Up Firebase
	1.	Create a Firebase project in Firebase Console
	2.	Add an Android & iOS app to Firebase
	3.	Download and place google-services.json (for Android) in android/app/
	4.	Download and place GoogleService-Info.plist (for iOS) in ios/Runner/
	5.	Enable Firebase Authentication (Email/Google Sign-In) and Firestore Database

4️⃣ Run the App
flutter run

⚡ How to Use

1️⃣ Register/Login with email & password or Google Sign-In
2️⃣ Create new tasks with title, description, priority, and due date
3️⃣ Add subtasks to break tasks into smaller steps
4️⃣ Edit tasks to update progress and status
5️⃣ Sync tasks online (automatically when connected)
6️⃣ Search & filter tasks for easy organization
7️⃣ Switch between Dark Mode & Light Mode

🔧 Tech Stack
	•	Flutter (Dart)
	•	Firebase Authentication (Email/Google Sign-In)
	•	Firebase Firestore (Cloud database & sync)
	•	SQLite (sqflite) (Local database)
	•	Bloc (Cubit) (State management)

🐛 Known Issues

🚨 Push Notifications for task reminders are not working yet.
✅ Other features work as expected.

🎯 Future Enhancements
	•	🔹 Push Notifications for task reminders
	•	🔹 Task Sharing & Collaboration
	•	🔹 More Filtering & Sorting Options
	•	🔹 Attachments (Files, Images)

📜 License
This project is open-source and available under the MIT License.

🤝 Contributing
🚀 Want to improve this project? Feel free to fork, improve, and submit a pull request!

🌟 Acknowledgments
Special thanks to the Flutter & Firebase community for their amazing resources.


🔥 Star this repo if you found it useful! 🚀
### 📌 How to Use This  
- Replace `"your-username"` in the `git clone` command with your actual GitHub username.  
- Paste this content into your `README.md` file in your project repository.  
- **Push to GitHub** and you're done! 🚀  

This **well-structured README** will make your project look professional and easy to set up for others. 🚀
