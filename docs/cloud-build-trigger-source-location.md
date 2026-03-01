# Cloud Build trigger fix: source location must point to runtime app folder

If your build history shows the error below, Cloud Build is likely running from repository root instead of the runtime app directory:

- `No buildpack groups passed detection`

Use that string as the search marker in Cloud Build history to find failing runs, then apply one of the two deployment paths below.

## Runtime app folder used in this repo

Use `cloud-run-service/` as the source location. It contains:

- `package.json`
- `server.js`
- `Dockerfile`

## Option A: Deploy Node service via buildpacks

1. In the trigger, set **Source location / Build context** to `cloud-run-service`.
2. Ensure `package.json` has a start script:
   - `"start": "node server.js"`
3. Use build config: `infra/cloudbuild/cloudbuild.node.yaml`.
4. Re-run the build and confirm buildpack detection succeeds.

## Option B: Deploy with Docker

1. In the trigger, set **Source location / Build context** to `cloud-run-service`.
2. Use build config: `infra/cloudbuild/cloudbuild.docker.yaml`.
3. Confirm Docker mode is selected (not auto buildpacks).
4. Re-run and confirm image build + push succeeds.

## Quick local sanity checks

From repo root:

```bash
node cloud-run-service/server.js
curl -sS localhost:8080/healthz
```

You should see a healthy JSON response from the service.
