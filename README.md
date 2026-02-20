# discover_egypt

A Flutter app for exploring and booking Egypt travel experiences.

## Runtime configuration

Pass non-secret runtime values with `--dart-define`:

```bash
flutter run \
  --dart-define=ENVIRONMENT=dev \
  --dart-define=API_BASE_URL=https://api-dev.discoveregypt.com/v1 \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=AIza...
```

Required values:

- `ENVIRONMENT` (`dev`, `stage`, or `prod`)
- `API_BASE_URL` (backend API base URL, including `/v1` if applicable)

Optional values:

- `STRIPE_PUBLISHABLE_KEY`
- `GOOGLE_MAPS_API_KEY`

> Do not commit secret keys. Stripe secret keys and payment intent creation/confirmation must run only on backend services.

See [docs/launch/RELEASE_READINESS.md](docs/launch/RELEASE_READINESS.md) for environment-specific launch examples.

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
