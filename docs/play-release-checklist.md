# Google Play release checklist (Android)

Use this checklist before every production rollout.

## 1) Android permission surface

- [ ] Confirm `android/app/src/main/AndroidManifest.xml` only contains required permissions:
  - `INTERNET` (API/Firebase/Stripe network traffic)
  - `ACCESS_NETWORK_STATE` (network-aware behavior)
  - `VIBRATE` (notification feedback)
- [ ] Confirm **not declared** unless the feature is reintroduced and fully implemented:
  - `CALL_PHONE`
  - `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION`
  - `CAMERA`
  - `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE`
  - `RECEIVE_BOOT_COMPLETED`

## 2) Sensitive permissions policy gate

If you add any sensitive runtime permission in future:

- [ ] Runtime request is implemented with explicit user action (never on app launch).
- [ ] In-app explanation is shown before the system prompt with:
  - clear feature reason,
  - what data is accessed,
  - what happens if denied.
- [ ] Play Console Data Safety + permission declaration forms are updated in the same release.

## 3) Data Safety form inputs (current baseline)

Update these values if implementation changes.

### Collected data categories

- [ ] **App activity**: Analytics events (`firebase_analytics`)
- [ ] **App info and performance**: Crash logs / diagnostics (`firebase_crashlytics`)
- [ ] **Personal info**: User account/auth identifiers (`firebase_auth`)
- [ ] **Financial info**: Payment metadata such as payment method/status/transaction ID used for bookings (Stripe + backend + Firestore records)

### Data handling declarations

- [ ] Data is encrypted in transit (HTTPS/TLS)
- [ ] Users can request account/data deletion (if exposed by product/legal flow)
- [ ] No unexpected sharing beyond declared processors (Firebase/Google, Stripe, backend infrastructure)

## 4) Build/signing pipeline checks

- [ ] `android/key.properties` is configured in CI or secure build agent for release.
- [ ] Release builds are signed with release key (debug signing is blocked unless explicitly overridden for local-only builds).
- [ ] `versionCode` incremented and `versionName` updated for each Play upload.
- [ ] `isMinifyEnabled = true` and `isShrinkResources = true` in release.
- [ ] Mapping file retention configured in CI for crash deobfuscation.

## 5) Pre-launch report verification

After uploading to internal/closed track:

- [ ] Run Play pre-launch report.
- [ ] Review crashes, ANRs, startup regressions.
- [ ] Review policy/security warnings (permissions, SDKs, cleartext, exported components).
- [ ] Verify deep links and core booking/payment flows on tested devices.
- [ ] Resolve or risk-accept each issue before promotion.
