# Release readiness: runtime environment settings

`Discover Egypt` now requires runtime/build-time environment settings via `--dart-define`.

## Required `--dart-define` values

- `ENVIRONMENT` (must be one of `dev`, `stage`, `prod`)
- `API_BASE_URL` (backend API base URL)

Optional:

- `STRIPE_PUBLISHABLE_KEY`
- `GOOGLE_MAPS_API_KEY`

## Environment launch examples

### Development

```bash
flutter run \
  --dart-define=ENVIRONMENT=dev \
  --dart-define=API_BASE_URL=https://api-dev.discoveregypt.com/v1 \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=AIza...
```

### Staging

```bash
flutter run --release \
  --dart-define=ENVIRONMENT=stage \
  --dart-define=API_BASE_URL=https://api-stage.discoveregypt.com/v1 \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_or_stage_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=AIza...
```

### Production

```bash
flutter build appbundle --release \
  --dart-define=ENVIRONMENT=prod \
  --dart-define=API_BASE_URL=https://api.discoveregypt.com/v1 \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_live_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=AIza...
```

## Startup validation behavior

At app startup, runtime configuration is validated.

- In debug/profile builds: validation issues are logged clearly.
- In release builds: missing/invalid required values cause fail-fast startup with an explicit error.

This behavior prevents accidentally shipping a release binary with missing API environment configuration.
