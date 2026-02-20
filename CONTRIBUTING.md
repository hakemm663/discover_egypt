# Contributing

## Security checklist for changes under `lib/`

Before opening a PR, verify all of the following:

- [ ] No secret-like constants are committed in `lib/`.
- [ ] Stripe secret operations (for example creating or confirming PaymentIntents) run on backend endpoints/cloud functions only.
- [ ] Mobile app uses Stripe publishable key only via runtime configuration (`--dart-define`).
- [ ] Secret scan passes:

```bash
./scripts/check_no_secret_constants.sh
```
