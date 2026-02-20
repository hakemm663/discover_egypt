# discover_egypt

A Flutter app for exploring and booking Egypt travel experiences.

## Runtime configuration

Pass non-secret runtime values with `--dart-define`:

```bash
flutter run \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_12345 \
  --dart-define=GOOGLE_MAPS_API_KEY=AIzaSyExampleKey
```

You can use the same keys for release builds:

```bash
flutter build appbundle --release \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_or_pk_test_key \
  --dart-define=GOOGLE_MAPS_API_KEY=AIzaSyExampleKey
```

> Do not commit secret keys. Stripe **secret** keys and payment intent creation/confirmation must run only on backend services.

## Environment matrix

Use separate Firebase and backend targets per environment.

| Environment | Firebase project ID | API base URL | Required secret/config source |
| --- | --- | --- | --- |
| Dev | `discover-egypt-95efd` | `https://api-dev.discoveregypt.com/v1` | Local developer machine (`.env` / `--dart-define`) |
| Staging | `discover-egypt-staging` | `https://api-staging.discoveregypt.com/v1` | CI secret manager (plus restricted local access for release engineers) |
| Prod | `discover-egypt-prod` | `https://api.discoveregypt.com/v1` | CI secret manager only |

Notes:
- The app currently has production API endpoint constants under `lib/core/constants/api_endpoints.dart`; introduce environment switching before promoting staging/prod release tracks.
- Keep `STRIPE_PUBLISHABLE_KEY` and `GOOGLE_MAPS_API_KEY` injected per environment via CI pipelines for non-dev builds.

## Android signing and release prerequisites

Before creating a Play Store upload (`.aab`), make sure Android release signing is configured.

1. Create a keystore (once):
   ```bash
   keytool -genkey -v \
     -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```
2. Create `android/key.properties` (do not commit this file):
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=/absolute/path/to/upload-keystore.jks
   ```
3. Confirm `android/app/build.gradle.kts` picks up `key.properties` for `release` signing config.
4. Build signed bundle:
   ```bash
   flutter build appbundle --release \
     --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx \
     --dart-define=GOOGLE_MAPS_API_KEY=AIzaSyLiveKey
   ```
5. Play Console flow:
   - Create/select app in Play Console.
   - Complete app content + Data safety + store listing.
   - Upload `build/app/outputs/bundle/release/app-release.aab` to Internal testing first.
   - Validate install, auth, payments, push notifications.
   - Promote to Closed/Open/Production tracks after sign-off.

## Pre-launch checklist

Before any staging/prod launch:

- [ ] Firebase
  - [ ] Correct `google-services.json` / `GoogleService-Info.plist` for target environment.
  - [ ] Crashlytics, Analytics, Auth providers, and FCM are enabled for the target Firebase project.
- [ ] Backend
  - [ ] `API base URL` responds to health checks (`/health` or equivalent).
  - [ ] Payment endpoints (`/payments/create-intent`, `/payments/confirm`) are reachable and authenticated.
- [ ] Stripe
  - [ ] Publishable key injected via `--dart-define=STRIPE_PUBLISHABLE_KEY=...`.
  - [ ] Webhook endpoint configured in Stripe Dashboard for target environment.
  - [ ] Webhook signing secret stored only in backend secret manager.
- [ ] Google Maps
  - [ ] `GOOGLE_MAPS_API_KEY` injected via `--dart-define=GOOGLE_MAPS_API_KEY=...`.
  - [ ] API key restrictions (Android package/SHA-1, iOS bundle ID) verified.
- [ ] Play Console assets
  - [ ] App icon, feature graphic, screenshots, short/long descriptions updated.
  - [ ] Privacy policy URL and support contact are valid.
  - [ ] Release notes added for the current track.

## Contributor security checklist

Before opening a PR:

- [ ] No secret-like constants are committed under `lib/`.
- [ ] Stripe operations requiring secrets run via backend endpoints/cloud functions.
- [ ] Device code uses publishable Stripe key only.
- [ ] Run secret scan:

```bash
./scripts/check_no_secret_constants.sh
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full contributor checklist.
