# CODEBASE DOCUMENTATION

## 🏗️ 1. Project Overview
- **Name**: `siz`
- **Description**: Flutter mobile app for browsing, listing, renting, chatting, and managing user profiles and orders for a fashion rental marketplace.
- **Primary Platform**: Android (iOS, Web, Desktop folders exist but Android is primary).
- **Flutter/Dart**:
  - Dart SDK: `>=3.1.2 <4.0.0` (see `pubspec.yaml`)
  - CI uses Flutter `3.13.5` (see `.github/workflows/main.yml`)
- **Key Packages**: Firebase (Core, Messaging), GetX (controllers), SharedPreferences, HTTP/Dio, Google Fonts, Local Notifications, Stripe, Pusher Channels, Geolocator/Geocoding, WebView.
- **Native Integrations**:
  - Firebase via `google-services.json`, Analytics enabled (see `android/app/build.gradle`)
  - FCM push notifications with foreground/local notifications (`lib/Utils/firebase_api.dart`)
  - Android deep links to `app.siz.ae` (`android/app/src/main/AndroidManifest.xml`)
  - Facebook SDK meta-data configured in AndroidManifest
  - Stripe via `flutter_stripe`
  - Pusher Channels for realtime chat via `pusher_channels_flutter`

## 🧩 2. Folder Structure & Architecture
```
/ (project root)
├─ lib/
│  ├─ AddItemsPages/              # Listing flow (images, brand, size, summary, etc.)
│  ├─ Controllers/                # GetX controllers (Profile, Chat, Filters, etc.)
│  ├─ Filters/                    # UI filters for categories, brands, etc.
│  ├─ HomePages/                  # Bottom navigation sections (Home, Browser, Add, Chat, Profile)
│  ├─ LoginSignUp/                # Splash, Login, OTP, Account creation
│  ├─ Pages/                      # Feature screens (Home, ProductView, Cart, Wishlist, etc.)
│  ├─ Utils/                      # Helpers: colors, constants, firebase api, values, etc.
│  └─ main.dart                   # App entry point
├─ android/                       # Native Android project, Gradle, Manifest, google-services.json
├─ ios/                           # iOS project scaffolding
├─ assets/images/                 # App images (configured in pubspec.yaml)
├─ test/                          # Tests (minimal)
├─ .github/workflows/main.yml     # GitHub Actions CI (build APK and release)
├─ flutter_native_splash.yaml     # Splash customization
├─ pubspec.yaml                   # Dependencies and assets
└─ README.md
```
- **Architecture Pattern**: MVC-ish with GetX Controllers. Business logic lives in `GetxController` classes under `lib/Controllers/`. UI screens read state from controllers via GetX `update()` and direct method calls.
- **Entry Point**: `lib/main.dart`
  - Initializes Flutter bindings and `Firebase.initializeApp()`
  - Sets portrait orientation via `SystemChrome`
  - Runs `MyAppLogin` which is a `StatefulWidget` managing deep links via `app_links` and a custom navigator key
  - `MaterialApp` provides routes with `'/' -> Splash()`
- **Initialization Sequence**:
  1. `main()` calls `Firebase.initializeApp()`
  2. `MyAppLogin.initState()` calls `initDeepLinks()` to process initial/warm links
  3. App shows `Splash` then navigates to `Home`

## 🔄 3. App Flow & Navigation
- **Navigation Stack**:
  - Standard `Navigator` with named route `'/'` bound to `Splash` (`lib/main.dart`)
  - Uses `page_transition` for animated transitions
  - Not using `GetMaterialApp` or `GoRouter`; navigation is mostly via `Navigator.push...` from screens
- **Startup Flow** (`lib/LoginSignUp/Splash.dart`):
  - 200ms animation, then after ~1.5s redirect to `Home` using `PageTransition`
- **Deep Links**:
  - `app_links` listens for initial and stream URIs
  - URIs like `https://app.siz.ae/product/<id>` open `ProductView` directly
  - AndroidManifest has `intent-filter` with `android:autoVerify="true"` for `app.siz.ae`

## ⚙️ 4. State Management
- **Approach**: GetX Controllers (`GetxController`) without `GetMaterialApp`.
- **Key Controllers** (`lib/Controllers/`):
  - `ProfileController` (`profileController` class): loads profile, closets, listings, rentals; drives multiple lists with pagination flags.
  - `ChatController`: chat list/detail fetching, Pusher realtime subscription, notifications campaign tracking.
  - Other controllers exist for filters, cart/promo, rent details, bottom nav, etc.
- **UI Reaction**: Controllers call `update()`; views should use GetX builders (in codebase many screens call controller methods and read controller fields). Snackbar helpers in controllers display errors via `ScaffoldMessenger`.

## 🌐 5. API & Backend Integration
- **Backend**: REST API
- **Base URL**: `http://app.siz.ae:4202` defined in `lib/Utils/Value.dart` as `SizValue.baseUrl`
- **HTTP Clients**:
  - Predominantly `package:http/http.dart` with `http.post`/`http.get`
  - `dio` is listed but sparsely used in some screens
- **Endpoints**: Centralized in `lib/Utils/Value.dart` as constants, e.g.:
  - Auth: `/auth/otp_login`, `/auth/verify_otp_login`, `/auth/complete_signup`
  - Data: `/data/categories`, `/data/brands`, `/data/sizes`, `/home/main`
  - Product: `/product/add`, `/product/edit`, `/product/detail`, `/product/my_listed`
  - Cart/Wishlist: `/cart/*`, `/wishlist/*`
  - Account: `/account/detail`, `/account/rentals`, `/account/requests`, `/account/logout`
  - Chat: `/chat/list`, `/chat/detail`, `/chat/send_message`
  - Payments: `/stripe/payment_intents`
- **Error Handling**:
  - Basic try/catch around network calls with specific catches for `ClientException`, `SocketException`, `HttpException`, `FormatException`
  - UI feedback via snackbars; some dialogs for loading states
- **Caching/Retry**: Not implemented at a framework level; relies on `SharedPreferences` for user/session metadata

## 🧱 6. Data Models
- **Style**: Dynamic maps decoded via `jsonDecode` with minimal typed models
- **Implication**: Be cautious; add null/format checks. Consider adding typed model classes and codegen (`json_serializable`) for robustness.

## 💾 7. Local Storage & Persistence
- **Storage**: `shared_preferences`
- **Keys** defined in `lib/Utils/Value.dart` (e.g., `SizValue.userKey`, `SizValue.firstname`, flags like `underReview`, etc.)
- **Usage**: Session info, user profile metadata, feature flags, and chat channel IDs

## 🖼️ 8. UI Components & Theming
- **Theme** (`lib/main.dart`):
  - `ThemeData` uses `GoogleFonts.lexendDecaTextTheme`
  - Custom `primarySwatch` with brand color `0xFFAF1010`
  - No splash effects: `NoSplash.splashFactory`
- **Colors**: `lib/Utils/Colors.dart` exposes `MyColors.themecolor`, `MyColors.themelight`
- **Shared UI**: Many reusable pages/components under `lib/Pages/` and `lib/AddItemsPages/` implement patterns for lists, filters, dialogs, and forms

## 🔐 9. Authentication & Security
- **Auth Flow**:
  - Phone OTP (`/auth/otp_login` then `/auth/verify_otp_login`)
  - Google sign-in package included (`google_sign_in`), and endpoints exist for Google login
  - Session persistence via `SharedPreferences` keys
- **Push Tokens**:
  - FCM configured in `lib/Utils/firebase_api.dart`; foreground/local notifications integrated with actions
  - Notification campaigns tracked via `/home/update_push_status`
- **Secrets**:
  - Firebase config in `android/app/google-services.json`
  - Keystore settings read from `android/key.properties` if present
  - Avoid committing real secrets; use CI secrets like `TOKENANDROID` in GitHub Actions

## ⚡ 10. Platform Integrations
- **Firebase**:
  - Core and Messaging packages
  - Android Gradle applies `com.google.gms.google-services` and Firebase BoM
- **Notifications**:
  - FCM + local notifications channel `high_importance_channel`
  - Custom fullscreen-like dialog for certain events (e.g., order_received)
- **Deep Links**:
  - AndroidManifest `intent-filter` with `http/https` scheme and `host="app.siz.ae"`
  - `flutter_deeplinking_enabled` meta-data set to true
- **Pusher**:
  - Realtime chat via `pusher_channels_flutter`; subscribes to channel from `SharedPreferences`
- **Location**:
  - `ACCESS_FINE_LOCATION` declared; geolocator/geocoding packages included
- **WebView**: Uses `webview_flutter`
- **Stripe**: `flutter_stripe` for payments; intent endpoint `/stripe/payment_intents`
- **Facebook SDK**: App ID and client token entries in Manifest; analytics/events via `facebook_app_events` package

## 🚀 11. Build & Deployment
- **Android Build Config** (`android/app/build.gradle`):
  - `minSdkVersion 26`, `targetSdkVersion 34`, Kotlin `jvmTarget 1.8`
  - Signing reads from `android/key.properties` (release)
  - Firebase BoM and Analytics dependency
- **Build Variants**: Default `debug`/`release`. No explicit flavor setup present.
- **Commands**:
  - Debug APK: `flutter build apk --debug`
  - Release APK: `flutter build apk --release`
  - App Bundle: `flutter build appbundle --release`
- **Keystore Setup**:
  - Create `android/key.properties` with `storeFile`, `storePassword`, `keyAlias`, `keyPassword`
  - Ensure keystore path is valid and not committed to VCS
- **CI/CD**: GitHub Actions (`.github/workflows/main.yml`)
  - Runs on `windows-latest`, sets up Java 17 and Flutter 3.13.5
  - Builds debug APK and attaches to GitHub Release tagged `v1.0.<run_number>`
  - Uses repo secret `TOKENANDROID`

## 🧠 12. Developer Setup & Onboarding
- **Prerequisites**:
  - Flutter SDK (>= 3.13.5 recommended), Dart SDK per `pubspec.yaml`
  - Android Studio + SDKs, Java 17
- **Environment**:
  - Ensure `google-services.json` exists at `android/app/`
  - Optional: `.env` if using `flutter_dotenv` (no references found in code yet)
- **Setup Steps**:
  1. `flutter pub get`
  2. Run on device/emulator: `flutter run`
  3. For push notifications on Android, ensure Play Services and a valid FCM project
- **Common Issues**:
  - Signing failures: check `android/key.properties`
  - Firebase errors: validate `google-services.json` and Gradle plugin `com.google.gms.google-services`
  - HTTP/Network: Device/emulator must access `http://app.siz.ae:4202` (consider Android cleartext config if needed)

## 📦 13. Dependencies Summary
- From `pubspec.yaml` (highlights only):
  - `get`: Lightweight state management/controllers
  - `shared_preferences`: Local key-value storage
  - `http` / `dio`: REST client libraries
  - `firebase_core`, `firebase_messaging`: Firebase core + FCM
  - `flutter_local_notifications`: Local notifications display
  - `app_links`: Deep link handling
  - `google_fonts`: Typography
  - `flutter_svg`, `lottie`, `cached_network_image`: Rich UI assets and images
  - `flutter_stripe`: Stripe payments
  - `pusher_channels_flutter`: Realtime chat updates
  - `geolocator`, `geocoding`: Location services
  - `webview_flutter`: WebView embedding
  - `url_launcher`, `share_plus`: External intents/sharing
  - `google_sign_in`, `facebook_app_events`: Social integrations
  - Many UI helper packages: tab bars, sliders, charts, accordions, etc.

For the full list, see `pubspec.yaml` dependencies.

## 🗺️ 14. Future Improvements / Known Issues
- **Typed Models**: Introduce model classes with `json_serializable` to replace dynamic maps and reduce runtime errors.
- **Error Handling**: Centralize networking with a repository/service layer, interceptors (if using Dio), standardized error/timeout handling, and retries/backoff.
- **State Management**: Consider adopting `GetMaterialApp` or a navigator binding strategy to fully leverage GetX reactive builders consistently, or migrate to a structured architecture (e.g., Clean Architecture with repositories/use-cases).
- **Configuration**: Extract environment/base URLs to `.env` per build flavor (dev/staging/prod) and configure multiple flavors.
- **Security**: Move secrets to secure storage/CI secrets. Audit any hard-coded keys (e.g., Pusher API key in `ChatController`).
- **Notifications**: Add iOS setup and Android 13+ notification permission handling if targeting iOS or newer Android behaviors.
- **Tests**: Add unit/widget tests for controllers and major flows.
- **Accessibility & Theming**: Expand theming, dark mode, and text scaling support.

---

# Appendix

## A. Key Files
- `lib/main.dart`: App bootstrap, deep link handling, theme
- `lib/LoginSignUp/Splash.dart`: Splash and initial redirect to home
- `lib/Utils/Value.dart`: All API endpoints and SharedPreferences keys
- `lib/Utils/firebase_api.dart`: FCM initialization and local notifications
- `lib/Controllers/ProfileController.dart`: Profile, closets, listings, account details
- `lib/Controllers/ChatController.dart`: Chat, realtime updates (Pusher), tracking

## B. Simple Flow Diagram
- Launch -> `main()` -> Firebase.init -> `MyAppLogin` -> Deep-link check -> `Splash` -> `Home`
- API calls -> `http.post` to endpoints in `SizValue`
- FCM message -> `FirebaseApi` -> local notification -> optional navigation to pages

## C. Build Cheatsheet
- Clean: `flutter clean && flutter pub get`
- Debug run: `flutter run -d <device>`
- Debug APK: `flutter build apk --debug`
- Release APK: `flutter build apk --release`
- Release AAB: `flutter build appbundle --release`
