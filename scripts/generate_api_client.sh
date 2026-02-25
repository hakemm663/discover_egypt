#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC_DIR="$ROOT_DIR/docs/openapi"
SPEC_PATH="$SPEC_DIR/discovery_api.openapi.json"
FETCHED_PATH="$SPEC_DIR/discovery_api.openapi.fetched.json"
OUT_DIR="$ROOT_DIR/lib/core/api/generated"

SCALAR_OPENAPI_URL="${SCALAR_OPENAPI_URL:-}"

mkdir -p "$SPEC_DIR" "$OUT_DIR"

if [[ -n "$SCALAR_OPENAPI_URL" ]]; then
  echo "Fetching OpenAPI spec from Scalar URL: $SCALAR_OPENAPI_URL"
  curl --fail --silent --show-error "$SCALAR_OPENAPI_URL" -o "$FETCHED_PATH"
  USE_SPEC="$FETCHED_PATH"
else
  echo "Using committed OpenAPI spec: $SPEC_PATH"
  USE_SPEC="$SPEC_PATH"
fi

python3 "$ROOT_DIR/scripts/generate_api_client.py" --spec "$USE_SPEC" --out "$OUT_DIR"

echo "Generated Dart API client in $OUT_DIR"
