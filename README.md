# 🌸 Bloom — Menstrual Cycle Tracker

A beautiful Flutter + Firebase app for tracking menstrual cycles, daily wellness, and health insights.

## 📱 App Screens

| Screen | Description |
|--------|-------------|
| **Splash** | Animated logo splash with route guard |
| **Auth** | Sign In / Register with Firebase Auth |
| **Calendar** | Monthly cycle calendar with period, ovulation, fertile window markers |
| **Daily Check-In** | Mood, symptoms, energy slider, flow intensity |
| **Health Insights** | Articles bento-grid (featured, nutrition, self-care, exercise) |
| **Cramp Relief** | Heat therapy, yoga poses, hydration tracker, herbal teas |
| **Settings** | Profile, cycle length editor, notification toggles, sign-out |

---

## 🚀 Setup Instructions

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** → name it `bloom-cycle` → Continue
3. Disable Google Analytics (optional) → **Create project**

### 2. Enable Firebase Services

In your Firebase project:
- **Authentication** → Sign-in method → **Email/Password** → Enable
- **Firestore Database** → Create database → **Start in test mode** → Choose region → Done

### 3. Add Android App to Firebase

1. In Firebase Console → **Project Overview** → Add app → Android
2. Package name: `com.bloom.bloomCycle`
3. Click **Register app** → Download `google-services.json`
4. Place `google-services.json` in: `android/app/google-services.json`

### 4. Add iOS App to Firebase (if needed)

1. Add app → iOS
2. Bundle ID: `com.bloom.bloomCycle`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### 5. Connect Firebase to Flutter (Easiest Method)

Install the FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

Then run from your project directory:
```bash
flutterfire configure
```

This automatically generates `lib/firebase_options.dart` with your real Firebase config.

### 6. Firestore Security Rules

In Firebase Console → Firestore → Rules, set:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 7. Run the App

```bash
cd bloom_cycle_app
flutter pub get
flutter run
```

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry + splash screen
├── firebase_options.dart        # ← Replace with generated file
├── theme/
│   └── app_theme.dart           # Color palette & theme
├── models/
│   └── cycle_data.dart          # Data models
├── services/
│   └── firebase_service.dart    # Firebase CRUD operations
├── providers/
│   └── app_provider.dart        # State management
├── widgets/
│   └── shared_widgets.dart      # Reusable UI components
└── screens/
    ├── auth_screen.dart         # Sign in / Register
    ├── home_shell.dart          # Bottom nav shell
    ├── calendar_screen.dart     # Monthly calendar
    ├── daily_checkin_screen.dart # Daily log entry
    ├── insights_screen.dart     # Health articles
    ├── relief_screen.dart       # Cramp relief guide
    └── settings_screen.dart     # User settings
```

---

## 🔥 Firestore Data Schema

```
users/
  {userId}/
    name: string
    email: string
    cycleLength: number (default: 28)
    periodLength: number (default: 5)
    lastPeriodStart: timestamp
    
    logs/
      {YYYY-MM-DD}/
        date: timestamp
        mood: number (0-3)
        symptoms: string[]
        energy: number (0-2)
        flow: number (0-4)
        notes: string?
```
