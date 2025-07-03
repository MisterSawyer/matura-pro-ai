# 📘 Matura Pro AI

A Flutter-based mobile/web app that allows users to register, log in, manage their account, and take a structured English placement test. Designed using the **MVC pattern** for clear separation of concerns and modularity.

---

## ✨ Features

- 📝 User registration and login (mock logic with password hashing)
- 👤 Account profile with editable name and test history
- 📚 Placement test with dynamic questions loaded from JSON
- ✅ Scoring and result screen with summary
- 📊 Result updates in real time on the user account
- 📂 Clean MVC folder structure for scalability

---

## 📁 Project Structure

```bash
matura_pro_ai/
├── lib/
│ ├── main.dart
│ ├── app/
│ ├── core/
│ ├── controllers/          # Business logic (Login, Register, Placement Test)
│ ├── models/               # Data models (Account, Question)
│ ├── routes/               # Named routes
│ └── views/
│ ├── login/
│ ├── register/
│ ├── home/
│ ├── account/
│ └── placement_test/       # Test UI + Result screen
├── assets/
│ └── placement_questions.json
├── pubspec.yaml
└── README.md
```

---

## 🧪 Sample Questions Format

Questions are stored in `assets/placement_questions.json`:

```json
{
  "question": "Choose the correct form: She ___ to the store yesterday.",
  "options": ["go", "went", "gone", "going"],
  "correctIndex": 1
}
```

## 🚀 Getting Started

### ✅ Prerequisites

- Flutter 3.10+ installed
- Dart SDK
- VS Code / Android Studio
- Emulator or physical device

### 🔧 Setup

``` bash
flutter pub get
flutter run
```

#### 🔗 Web

```bash
flutter run -d chrome
```
