# Coach Devanshi Doshi Mobile Application

A premium health, wellness, and holistic coaching mobile application built with **Flutter**, designed to empower clients with personalized health journeys, daily wellness check-ins, multi-phase coaching pathways, and seamless wearable health data synchronization.

---

## 📱 Features & Highlights

### 1. 🔐 Authentication & Onboarding
- **Multi-method Sign-in**: Phone Number authentication with OTP verification, Email/Password authentication, and Social Sign-In (**Google Sign-In** & **Sign in with Apple**).
- **Comprehensive Client Onboarding**: 6-part clinical & lifestyle intake workflow:
  - **Chapter 1**: Profile & Program Selection
  - **Chapter 2**: Goals & Starting Point
  - **Chapter 3**: Health & Safety Intake
  - **Chapter 4**: Food & Digestion Intake
  - **Chapter 5**: Lifestyle & Coaching Fit
  - **Chapter 6**: Mindset & Sustainability
- **Consent & Agreement**: Digital client consent, coaching policies, and terms acceptance.

### 2. 🏠 Interactive Daily Dashboard
- **Personalized Daily Touchpoints**: Dynamic greeting, restorative mindfulness nudges, and daily coach notes.
- **Active Plan Summary**: Visual progress ring, timeline countdown, current phase, and one-tap pathway protocol navigation.
- **Today's Overview**: Live daily step counts, weight trend tracking (gain/loss indicator), and real-time check-in status.
- **Weekly Rhythm & Calendar Strip**: Visual week-at-a-glance check-in cadence tracker.
- **Quick Access Hub**: Instant navigation to Food Diary, Photo Logs, Blood Reports, and Check-ins.
- **Resilient UI**: Smooth shimmer loading skeletons and retry states on network issues.

### 3. 🌿 Personalized Coaching Pathways & Protocols
Dynamic clinical tracks and protocols with custom intake forms and habit matrices:
- **Gut Reset Protocol**: Microbiome rebalancing, gut motility, acid reflux relief & digestive wellness.
- **Fat Loss & Inch Loss**: Sustainable metabolic tuning and body recomp without restrictive dieting.
- **Healthy Weight Gain**: Caloric density, nutrient absorption, and lean tissue support.
- **Rooted Recovery for New Moms**: Postpartum healing, restorative nourishment, and gentle hormonal sync.
- **Maintenance & Lifestyle**: Long-term metabolic resilience and intuitive eating rhythms.
- **Reproductive Life-Stage Modules**: Cycle-syncing, maternal care, and hormonal health protocols.

### 4. 📝 Daily & Weekly Check-ins
- **Daily Wellness Log (Micro Check-in)**: Track energy levels, sleep hours/quality, hydration, meals, mood, digestion, and expressive journaling notes.
- **Baseline Measurements**: 7-day initial biometric calibration.
- **Weekly Progress & Measurements**: Waist, hip, abdomen, and weight tracking with before/after progress photo upload.
- **3-Day Food Diary**: Photo-based and descriptive meal logging.

### 5. ⌚ Health & Wearables Integration
- Automatic & manual synchronization of daily step counts and activity metrics via **Apple Health** (iOS) and **Health Connect / Google Fit** (Android).
- Foreground and background auto-sync triggered when health permissions are active.

### 6. 📄 Clinical Documents & Lab Reports
- **Blood Report Upload**: Multi-file document upload (PDF, JPEG, PNG) with in-app PDF viewer and management.

---

## 🏗️ Architecture & Tech Stack

This project follows **Clean Architecture** and strict separation of concerns:

```
lib/
├── core/
│   ├── blocs/          # State management (flutter_bloc) organized by feature
│   │   ├── auth/
│   │   ├── home/
│   │   ├── coach/
│   │   ├── profile/
│   │   └── progress/
│   ├── constants/      # App colors, icons, images, API URLs, and utilities
│   ├── models/         # Strongly-typed data models with JSON serialization
│   ├── network/        # Dio HTTP client, base request handler & interceptors
│   │   ├── client/
│   │   ├── contracts/
│   │   └── interceptors/ # Auth, Logging & Error Interceptors
│   ├── repository/     # Data repositories abstracting API communication
│   └── services/       # Core services (Auth, Health, Preferences, Navigation)
├── ui/
│   ├── screens/        # Modular UI feature screens (Auth, Home, Coach, Profile, Check-in, Progress)
│   └── widgets/        # Reusable design system components (buttons, cards, text fields, avatars)
├── firebase_options.dart # Generated Firebase configuration for iOS & Android
└── main.dart           # App entry point, MultiBlocProvider setup & theme init
```

### Key Libraries & Tools:
- **State Management**: [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (v9.x) with [`equatable`](https://pub.dev/packages/equatable)
- **Networking**: [`dio`](https://pub.dev/packages/dio) with custom logging and token authentication interceptors
- **Authentication**: [`firebase_auth`](https://pub.dev/packages/firebase_auth), [`google_sign_in`](https://pub.dev/packages/google_sign_in), [`sign_in_with_apple`](https://pub.dev/packages/sign_in_with_apple)
- **Health Data**: [`health`](https://pub.dev/packages/health) (Apple HealthKit & Android Health Connect)
- **Storage**: [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- **UI Components**: [`cached_network_image`](https://pub.dev/packages/cached_network_image), [`shimmer`](https://pub.dev/packages/shimmer), [`pinput`](https://pub.dev/packages/pinput), [`country_code_picker`](https://pub.dev/packages/country_code_picker)
- **PDF & Media**: [`syncfusion_flutter_pdfviewer`](https://pub.dev/packages/syncfusion_flutter_pdfviewer), [`file_picker`](https://pub.dev/packages/file_picker), [`image_picker`](https://pub.dev/packages/image_picker)

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>= 3.13.0` (Recommended: Flutter `3.24.x` or higher)
- **Dart SDK**: `^3.13.0`
- **Android Studio** / **VS Code** with Flutter and Dart plugins
- **Xcode** (for macOS / iOS development)
- Java 17+ for Android Gradle builds

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd coachdevanshi
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Android: Ensure `android/app/google-services.json` is properly placed.
   - iOS: Ensure `ios/Runner/GoogleService-Info.plist` is properly added in Xcode.
   - `lib/firebase_options.dart` is pre-configured with project credentials.

4. **Run the App**:
   ```bash
   # Debug mode
   flutter run

   # Target specific device
   flutter run -d <device_id>
   ```

---

## 📦 Build Instructions

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build iOS Release
flutter build ios --release
```

---

## 🎨 Design & Typography

The application uses a custom-tailored wellness design system:
- **Primary Palette**: Botanical greens, warm wellness rose, soft neutrals, and clean surface tones.
- **Typography**:
  - **Plus Jakarta Sans**: Modern sans-serif for UI labels, metrics, body copy, and inputs.
  - **Playfair Display**: Elegant serif typography for editorial headers, coaching prompts, and brand identity.
