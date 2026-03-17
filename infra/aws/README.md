# AWS Core Deployment

This folder holds the AWS-first production deployment scaffold for the Discover Egypt platform.

## Target topology

- ECS Fargate service for the NestJS API
- RDS PostgreSQL as system of record
- ElastiCache Redis for caching, search hot paths, and rate limiting
- S3 + CloudFront for media delivery
- Secrets Manager for runtime secrets
- CloudWatch for logs, metrics, and alarms

Firebase remains the mobile/web client service layer for Auth, FCM, Analytics, and Crashlytics.
