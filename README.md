# Discover Egypt

Production-grade Flutter application for discovering, planning, and booking travel experiences across Egypt (hotels, tours, cars, restaurants) with secure payment and Firebase-backed user flows.

---

## Project status and major upgrades delivered

This repository has evolved from a simple catalog app into a modular booking platform with:

- **Multi-domain travel discovery**: hotels, tours, cars, restaurants, and a trip planner.
- **End-to-end booking flow**: summary, payment confirmation, and success handling.
- **Modern app architecture**: Riverpod state management + repository pattern + typed models.
- **Scalable navigation**: `go_router` with shell routing and animated transitions.
- **Production observability & platform tooling**: Firebase Analytics, Crashlytics, Messaging, and release hardening scripts.
- **Security-first runtime config**: secrets moved out of source code and injected at runtime.

---

## Core capabilities

### Traveler experience
- Onboarding flow (cover, language, nationality, interests)
- Authentication (sign up, sign in, forgot password)
- Home feed with recommendations and featured destinations
- Hotels, tours, cars, restaurants listing/detail pages
- Booking summary and payment success journey
- Wallet/profile area, reviews, support center, legal pages

### Platform features
- Firebase integration (Auth, Firestore, Storage, Messaging, Analytics, Crashlytics)
- Stripe publishable-key based mobile payment integration
- Shared design system widgets and reusable UI primitives
- Localization support (`app_en.arb`, `app_ar.arb`)
- Cross-platform Flutter targets (Android, iOS, web, desktop scaffolding)

---

## Tech stack ("hardcore tools" used)

Instead of a basic single-screen/mobile-only setup, this app uses production-ready tooling:

### App framework
- **Flutter 3 / Dart 3**

### Architecture & state
- **flutter_riverpod** for predictable, testable state management
- **Repository + API client + Firestore client layering** for maintainable data flows

### Navigation
- **go_router** with `StatefulShellRoute.indexedStack` for tabbed app navigation

### Backend & cloud services
- **Firebase Core, Auth, Firestore, Storage**
- **Firebase Messaging** (push readiness)
- **Firebase Analytics + Crashlytics** (monitoring and crash reporting)

### Payments
- **flutter_stripe** with runtime publishable-key injection
- Backend-only secret operations policy for PaymentIntent creation/confirmation

### Networking & local data
- **dio** for HTTP
- **hive_flutter** and **shared_preferences** for local persistence
- **connectivity_plus** for network-awareness utilities

### UX and UI acceleration
- `cached_network_image`, `shimmer`, `carousel_slider`, `flutter_animate`, `smooth_page_indicator`, `confetti`, `flutter_rating_bar`

### Dev & release tooling
- `flutter_test`, `flutter_lints`
- `build_runner`
- `flutter_launcher_icons`, `flutter_native_splash`
- Security scan script: `scripts/check_no_secret_constants.sh`
- Windows SDK bootstrap helper: `scripts/fix_android_sdk_windows.ps1`

---

## Repository structure

```text
lib/
  app/                  # App bootstrap + global providers
  core/
    config/             # Runtime config and environment reads
    api/generated/      # Generated Dart SDK from OpenAPI (do not hand edit)
    constants/          # API endpoints, app constants, assets URLs
    repositories/       # Repository contracts + API clients + Firestore adapters
    routes/             # go_router route graph
    services/           # Auth, DB, payment, notifications, firebase wrappers
    themes/             # Theme/colors
    widgets/            # Shared reusable widgets
  features/
    auth/ onboarding/ home/ hotels/ tours/ cars/ restaurants/
    booking/ profile/ support/ settings/ legal/ shared/
```


## API spec -> generated Dart client workflow

The app now uses a reproducible OpenAPI-driven client generation workflow:

- Source spec (committed fallback): `docs/openapi/discovery_api.openapi.json`
- Optional Scalar source (remote): set `SCALAR_OPENAPI_URL` when generating
- Generated SDK output: `lib/core/api/generated/`
- Hand-written adapters/repository-facing clients: `lib/core/repositories/api_clients/`

### Regenerate the SDK

```bash
./scripts/generate_api_client.sh
```

To pull from a Scalar-managed OpenAPI document instead of the committed spec:

```bash
SCALAR_OPENAPI_URL="https://your-scalar-host/openapi.json" ./scripts/generate_api_client.sh
```

### CI guard (generated code drift)

CI runs:

```bash
./scripts/check_generated_api_client.sh
```

This command regenerates files and fails if `lib/core/api/generated/` changes, which enforces that generated client code and the committed spec stay in sync.

---

## App screens



---

## Runtime configuration

✅ The app is **ready for API configuration** using runtime `--dart-define` values, so you can point it to your chosen environment without changing source code.

Inject **non-secret** client config at runtime:

```bash
flutter run \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_12345 \
  --dart-define=GOOGLE_MAPS_API_KEY=AIzaSyExampleKey
```

Release build example:

```bash
flutter build appbundle --release \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_or_pk_test_key \
  --dart-define=GOOGLE_MAPS_API_KEY=AIzaSyExampleKey
```

> Never commit secret keys. Stripe secret key and PaymentIntent secret operations must remain on backend services only.

---


## Social auth platform setup (Google + Facebook)

To avoid partially wired UI, social buttons are hidden by default and only appear when runtime flags are enabled:

```bash
flutter run   --dart-define=ENABLE_GOOGLE_AUTH=true   --dart-define=ENABLE_FACEBOOK_AUTH=true
```

### Android requirements

1. Add **both debug and release SHA-1/SHA-256 fingerprints** to your Firebase Android app.
2. In Firebase Console -> Authentication -> Sign-in method, enable **Google** and **Facebook** providers.
3. For Google auth, confirm the Android OAuth client entries exist for each signing fingerprint.
4. For Facebook auth, set the Android package name and app key hash in the Facebook developer console.

Useful command for fingerprints:

```bash
./gradlew signingReport
```

### iOS requirements

1. In `ios/Runner/Info.plist`, add URL schemes required by Google/Facebook SDK integration.
2. Ensure `CFBundleURLTypes` includes the reversed client id from `GoogleService-Info.plist`.
3. Add Facebook plist keys (for example `FacebookAppID`, `FacebookClientToken`, `FacebookDisplayName`) and the required query schemes.
4. Ensure Firebase Auth providers are enabled in the Firebase Console for the iOS app bundle id.

### Config references in this repo

- Runtime social flags and optional test token defines: `lib/core/config/app_config.dart`
- Firebase credential exchange methods (Google/Facebook): `lib/core/services/auth_service.dart`
- Sign-in UI conditional social rendering + loading/error/cancel/linking handling: `lib/features/auth/sign_in_page.dart`

> Development-only token injection exists for controlled testing of Firebase credential exchange (`GOOGLE_ID_TOKEN_FOR_TESTING`, `GOOGLE_ACCESS_TOKEN_FOR_TESTING`, `FACEBOOK_ACCESS_TOKEN_FOR_TESTING`). Production builds should use native SDK token acquisition instead.

---

## Firebase runtime/deployment setup (including web)

`lib/firebase_options.dart` is expected to be generated from FlutterFire and now includes a `web` target so `DefaultFirebaseOptions.currentPlatform` resolves correctly on browser builds.

### Required setup

1. Install Flutter + Dart + FlutterFire CLI locally:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Log in to Firebase and select the intended project for your environment (dev/staging/prod).
3. Regenerate options with web explicitly included:
   ```bash
   flutterfire configure \
     --project=discover-egypt-95efd \
     --platforms=android,ios,web \
     --android-package-name=com.discoveregypt.app \
     --ios-bundle-id=com.discoveregypt.app
   ```
4. Commit the regenerated `lib/firebase_options.dart` and verify the generated `web` block points to the intended Firebase project before deployment.

> For staging/prod, re-run the same command with the environment-specific Firebase project id to avoid cross-environment analytics/auth data leakage.

## Environment matrix

| Environment | Firebase project ID | API base URL | Config source |
| --- | --- | --- | --- |
| Dev | `discover-egypt-95efd` | `https://api-dev.discoveregypt.com/v1` | Local `.env` / `--dart-define` |
| Staging | `discover-egypt-staging` | `https://api-staging.discoveregypt.com/v1` | CI secret manager + restricted release access |
| Prod | `discover-egypt-prod` | `https://api.discoveregypt.com/v1` | CI secret manager only |

---

## Android release and signing

1. Create keystore:
   ```bash
   keytool -genkey -v \
     -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```
2. Add `android/key.properties` (do not commit):
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=/absolute/path/to/upload-keystore.jks
   ```
3. Ensure `android/app/build.gradle.kts` loads signing values.
4. Build signed AAB:
   ```bash
   flutter build appbundle --release \
     --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx \
     --dart-define=GOOGLE_MAPS_API_KEY=AIzaSyLiveKey
   ```

---

## Pre-launch gate checklist

For the full Android Play rollout process (permissions, Data Safety form, signing, and pre-launch report verification), use [`docs/play-release-checklist.md`](docs/play-release-checklist.md).

- [ ] Firebase project mapping verified by environment
- [ ] Backend health and payment endpoints reachable
- [ ] Stripe publishable key + webhook config validated
- [ ] Google Maps key restrictions verified
- [ ] Store listing assets, policy URLs, release notes updated

---

## Security and contribution workflow

Before every PR:

- [ ] No secret-like constants under `lib/`
- [ ] Sensitive Stripe operations only in backend
- [ ] Runtime publishable key wiring validated
- [ ] Secret scan passed

```bash
./scripts/check_no_secret_constants.sh
```

---

## Web deployment (Firebase Hosting)

This project is configured to deploy Flutter web as **static assets** on Firebase Hosting.

### Files committed for hosting

- `firebase.json` with `hosting.public` set to `build/web`
- `.firebaserc` with the default Firebase project

### Build and deploy

1. Build Flutter web release artifacts:

   ```bash
   flutter build web --release
   ```

2. Deploy static files to Firebase Hosting:

   ```bash
   firebase deploy --only hosting
   ```

### Notes

- `firebase.json` includes a rewrite from `**` to `/index.html` so deep links work in the Flutter web SPA.
- Ensure you are authenticated (`firebase login`) and have access to the configured Firebase project before deploying.

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

---

## Useful commands

```bash
# Fetch dependencies
flutter pub get

# Static analysis
flutter analyze

# Run tests
flutter test

# Run app
flutter run
```

---

## Windows Android SDK fix helper

If `flutter doctor` reports missing `cmdline-tools` or unknown Android license status, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\fix_android_sdk_windows.ps1
```

Then confirm:
- `ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk`
- `ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk`
- `Path` contains:
  - `%ANDROID_HOME%\platform-tools`
  - `%ANDROID_HOME%\cmdline-tools\latest\bin`
