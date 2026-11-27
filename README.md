# Coach Devanshi Doshi Mobile Application

A premium health, wellness, and holistic coaching mobile application built with **Flutter**, designed to empower clients with personalized health journeys, daily wellness check-ins, multi-phase coaching pathways, real-time notifications, and seamless wearable health data synchronization.

---

## 📱 Features & Highlights

### 1. 🔐 Authentication & Onboarding
- **Multi-method Sign-in**: Phone Number authentication with OTP verification, Email authentication with OTP, and Social Sign-In (**Google Sign-In** & **Sign in with Apple**).
- **Comprehensive Client Onboarding**: 6-part clinical & lifestyle intake workflow:
  - **Chapter 1**: Profile & Program Selection
  - **Chapter 2**: Goals & Starting Point
  - **Chapter 3**: Health & Safety Intake
  - **Chapter 4**: Food & Digestion Intake
  - **Chapter 5**: Lifestyle & Coaching Fit
  - **Chapter 6**: Mindset & Sustainability
- **Consent & Agreement**: Digital client consent, coaching policies, and terms acceptance.

### 2. 🏠 Interactive Daily Dashboard
- **Personalized Daily Touchpoints**: Dynamic greeting, restorative mindfulness nudges, and an expandable **Note from Coach** card (`show more` / `show less` toggle for long notes).
- **Active Plan Summary**: Visual progress ring, timeline countdown, current phase, and one-tap smart routing directly to the assigned pathway protocol screen.
- **Today's Overview**: Live daily step counts, weight trend tracking (gain/loss indicator), and real-time check-in status.
- **Weekly Rhythm & Calendar Strip**: Visual week-at-a-glance check-in cadence tracker.
- **Quick Access Hub**: Instant navigation to Food Diary, Photo Logs, Blood Reports, and Check-ins.
- **Resilient UI**: Smooth shimmer loading skeletons and error retry states on network failures.

### 3. 🌿 Personalized Coaching Pathways & Protocols
Dynamic clinical tracks and protocols with custom intake forms and habit matrices:
- **Gut Reset Protocol**: Microbiome rebalancing, gut motility, acid reflux relief & digestive wellness.
- **Fat Loss & Inch Loss**: Sustainable metabolic tuning and body recomp without restrictive dieting.
- **Healthy Weight Gain**: Caloric density, nutrient absorption, and lean tissue support.
- **Rooted Recovery for New Moms**: Postpartum healing, restorative nourishment, and gentle hormonal sync.
- **Maintenance & Lifestyle**: Long-term metabolic resilience and intuitive eating rhythms.
- **Reproductive Life-Stage Modules**: Cycle-syncing, maternal care, and hormonal health protocols.

### 4. 📝 Daily & Weekly Check-ins
- **Daily Wellness Log (Micro Check-in)**:
  - Dynamic **D1–D7** week selector synchronized with the active week's calendar dates (Monday–Sunday) and the "Date of Record" date picker.
  - Track circadian rhythm & rest (weight, wake/bed times, sleep quality), movement & hydration, mindset & rituals (meditation, journaling), and structured meals.
- **Baseline Measurements**: 7-day initial biometric calibration.
- **Weekly Progress & Measurements**: Waist, hip, abdomen, and weight tracking with before/after progress photo upload.
- **3-Day Food Diary**: Photo-based and descriptive meal logging.

### 5. ⌚ Health & Wearables Integration
- Automatic & manual synchronization of daily step counts, distance, active calories, and workouts via **Apple Health** (iOS) and **Health Connect / Google Fit** (Android).
- Automatic foreground health sync triggered on app launch when a connected `health_source` is configured in the user profile.

### 6. 🔔 Push Notifications & In-App Notification Center
- **FCM Push Notifications**: Firebase Cloud Messaging paired with `flutter_local_notifications` for foreground banners, background delivery, and tap navigation.
- **Automatic Device & Token Sync**: Registers `fcm_token`, `device_type` (`android`/`ios`), and `device_name` on launch via `DeviceInfoService` and `FcmTokenBloc`.
- **Notification Center (`NotificationsScreen`)**:
  - Categorized notification cards with contextual badges, unread dot/border indicators, and formatted timestamps (`dd-MM-yyyy hh:mm a`).
  - Pull-to-refresh, shimmer loading skeletons, empty states, and retry states.
  - Marks notifications as read (`markNotificationRead`) on tap and deep-links to the corresponding pathway protocol or bottom navigation tab.

### 7. 📄 Clinical Documents & Lab Reports
- **Blood Report Upload**: Multi-file document upload (PDF, JPEG, PNG) with in-app PDF viewer and file management.

---

## 🏗️ Architecture & Tech Stack

This project follows **Clean Architecture** and strict separation of concerns:

```
lib/
├── core/
│   ├── blocs/            # State management (flutter_bloc) organized by feature
│   │   ├── auth/         # Login, Signup, OTP, Social, Profile, Logout, FcmToken
│   │   ├── coach/        # Pathways & protocol intake forms
│   │   ├── home/         # Dashboard, DailyCheckin, SaveDailyCheckin, HealthSync
│   │   ├── notifications/# NotificationsBloc & MarkNotificationReadBloc
│   │   ├── profile/      # Location, Onboarding Masters, Chapters 1-6, Blood Reports
│   │   ├── progress/     # Weekly Check-in, Progress Photos, Food Diary
│   │   └── bloc_list.dart# Central MultiProvider BLoC registry
│   ├── constants/        # App colors, icons, images, API URLs, and utilities
│   ├── models/           # Strongly-typed data models with JSON serialization
│   ├── network/          # Dio HTTP client, base request handler & interceptors
│   │   ├── client/
│   │   ├── contracts/
│   │   └── interceptors/ # Auth, Logging & Error Interceptors
│   ├── repository/       # Data repositories abstracting API communication
│   └── services/         # Core services (Auth, Health, Notification, DeviceInfo, AppVersion, Preferences, Loader, Navigation)
├── ui/
│   ├── screens/          # Modular UI feature screens (Auth, Home, Coach, Profile, Check-in, Progress, Notifications)
│   └── widgets/          # Reusable design system components (buttons, cards, text fields, app bars)
├── firebase_options.dart # Generated Firebase configuration for Android & iOS
└── main.dart             # App entry point, Firebase init, preferences, & root config
```

### Key Libraries & Tools:
- **State Management**: [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (`^9.1.1`), [`provider`](https://pub.dev/packages/provider), and [`equatable`](https://pub.dev/packages/equatable)
- **Networking & Connectivity**: [`dio`](https://pub.dev/packages/dio) with custom logging, error, and auth interceptors; [`connectivity_plus`](https://pub.dev/packages/connectivity_plus); [`webview_flutter`](https://pub.dev/packages/webview_flutter)
- **Authentication**: [`firebase_core`](https://pub.dev/packages/firebase_core), [`firebase_auth`](https://pub.dev/packages/firebase_auth), [`google_sign_in`](https://pub.dev/packages/google_sign_in), [`sign_in_with_apple`](https://pub.dev/packages/sign_in_with_apple)
- **Notifications**: [`firebase_messaging`](https://pub.dev/packages/firebase_messaging), [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications)
- **Health Data**: [`health`](https://pub.dev/packages/health) (Apple HealthKit & Android Health Connect)
- **Storage & Device Info**: [`shared_preferences`](https://pub.dev/packages/shared_preferences), [`package_info_plus`](https://pub.dev/packages/package_info_plus), [`device_info_plus`](https://pub.dev/packages/device_info_plus)
- **UI Components & Utilities**: [`cached_network_image`](https://pub.dev/packages/cached_network_image), [`shimmer`](https://pub.dev/packages/shimmer), [`pinput`](https://pub.dev/packages/pinput), [`country_code_picker`](https://pub.dev/packages/country_code_picker), [`intl`](https://pub.dev/packages/intl)
- **PDF & Media**: [`syncfusion_flutter_pdfviewer`](https://pub.dev/packages/syncfusion_flutter_pdfviewer), [`file_picker`](https://pub.dev/packages/file_picker), [`image_picker`](https://pub.dev/packages/image_picker)

---

## 🚀 Getting Started

### Prerequisites
- **Dart SDK**: `^3.13.0`
- **Flutter SDK**: Compatible with Dart `^3.13.0`
- **Android Studio** / **VS Code** with Flutter and Dart plugins
- **Xcode** (for macOS / iOS development, targeting iOS `15.0+`)
- **Java 17** for Android Gradle builds (Android `compileSdk = 37`, `minSdk = 26`, core library desugaring enabled)

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
   - **Android** (`com.coach.devanshi.doshi`): Ensure `android/app/google-services.json` is properly placed.
   - **iOS** (`com.coach.devanshi.doshi`): Ensure `ios/Runner/GoogleService-Info.plist` is properly added in Xcode with Push Notifications, Sign in with Apple, and HealthKit capabilities enabled.
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
