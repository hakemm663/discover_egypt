# discover_egypt

A Flutter app for exploring and booking Egypt travel experiences.

## Runtime configuration

Pass non-secret runtime values with `--dart-define`:

```bash
flutter run \
  --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx \
  --dart-define=GOOGLE_MAPS_API_KEY=AIza...
```

> Do not commit secret keys. Stripe secret keys and payment intent creation/confirmation must run only on backend services.

## Contributor security checklist

Before opening a PR:

- [ ] No secret-like constants are committed under `lib/`.
- [ ] Stripe operations requiring secrets run via backend endpoints/cloud functions.
- [ ] Device code uses publishable Stripe key only.
- [ ] Run secret scan:

```bash
./scripts/check_no_secret_constants.sh
```
