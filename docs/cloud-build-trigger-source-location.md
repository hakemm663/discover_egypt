# Cloud Build trigger fix: source location must point to runtime app folder

If your build history shows the error below, Cloud Build is likely running from repository root instead of the runtime app directory:

- `No buildpack groups passed detection`

Use that string as the search marker in Cloud Build history to find failing runs, then apply one of the two deployment paths below.

## Runtime app folder used in this repo

Use `cloud-run-service/` as the source location. It contains:

- `package.json`
- `server.js`
- `Dockerfile`

## Required trigger setting change

In **Google Cloud Build → Triggers → <your trigger> → Edit**, set:

- **Source location / Build context**: `cloud-run-service/`

For Firebase App Hosting (backend builds), set the backend build source path to the same `cloud-run-service/` folder.

## Option A: Deploy Node service via buildpacks

1. In the trigger, set **Source location / Build context** to `cloud-run-service/`.
2. Ensure `package.json` has a start script:
   - `"start": "node server.js"`
3. Use build config: `infra/cloudbuild/cloudbuild.node.yaml`.
4. Re-run the same trigger and confirm buildpack detection succeeds.

## Option B: Deploy with Docker

1. In the trigger, set **Source location / Build context** to `cloud-run-service/`.
2. Use build config: `infra/cloudbuild/cloudbuild.docker.yaml`.
3. Confirm Docker mode is selected (not auto buildpacks).
4. Re-run and confirm image build + push succeeds.

## Verification checklist after rerun

In the new build log for the rerun, verify detection moved past the previous failure point:

1. Buildpack detection references app files from `cloud-run-service/` (including `cloud-run-service/package.json`).
2. The build does **not** stop at `No buildpack groups passed detection`.
3. Later build stages begin (build/install/export for buildpacks, or docker build steps for Docker mode).

## Quick local sanity checks

From repo root:

```bash
node cloud-run-service/server.js
curl -sS localhost:8080/healthz
```

You should see a healthy JSON response from the service.
