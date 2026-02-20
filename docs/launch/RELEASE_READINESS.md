# Release Readiness Checklist (Google Play + App Store)

Use this checklist before every production release.

## 1) Security and payments

- [ ] Stripe **secret key is never in app code** (`lib/`).
- [ ] PaymentIntent creation/confirmation requiring secrets runs only on backend/cloud functions.
- [ ] App only initializes Stripe with publishable key from runtime config (`--dart-define=STRIPE_PUBLISHABLE_KEY=...`).
- [ ] `./scripts/check_no_secret_constants.sh` passes.

## 2) Build and quality gates

- [ ] `flutter pub get`
- [ ] `dart format --output=none --set-exit-if-changed lib test`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] CI workflow (`.github/workflows/mobile-ci.yml`) is green.

## 3) App configuration

- [ ] Production `--dart-define` values are provided in CI/CD (no hardcoded keys).
- [ ] Correct Firebase projects are configured for production.
- [ ] Android signing config and iOS signing profiles are valid.

## 4) Store compliance

- [ ] Privacy Policy URL is live and accurate.
- [ ] Data safety / privacy nutrition labels are updated to match app behavior.
- [ ] Permission usage descriptions are clear and user-facing.
- [ ] Support email and contact links are valid.

## 5) Release operations

- [ ] Crashlytics and analytics dashboards are monitored.
- [ ] Rollout plan defined (staged rollout / phased release).
- [ ] Rollback plan prepared.
