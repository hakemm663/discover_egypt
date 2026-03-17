# ADR 0001: Discover Egypt Production Monorepo

## Status

Accepted

## Decision

- Keep the Flutter client in the repository root.
- Add `backend/api` as the NestJS modular monolith.
- Keep `contracts/openapi` as the API contract source of truth for generated mobile clients.
- Use PostgreSQL as the system of record, Redis for cache/hot paths, and S3/CloudFront for media.
- Use Firebase for Auth, FCM, Analytics, and Crashlytics.
- Use Stripe Connect Express for marketplace payments and vendor payouts.

## Consequences

- Mobile, web dashboard, backend, contracts, and infra remain versioned together.
- The Flutter app can evolve alongside API contracts without drift.
- AWS owns the core backend/runtime path while Firebase stays focused on client platform services.
