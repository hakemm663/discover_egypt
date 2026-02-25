#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT_DIR/scripts/generate_api_client.sh"

if ! git -C "$ROOT_DIR" diff --quiet -- lib/core/api/generated; then
  echo "Generated API client is out of date. Run ./scripts/generate_api_client.sh and commit changes."
  git -C "$ROOT_DIR" --no-pager diff -- lib/core/api/generated
  exit 1
fi

echo "Generated API client is up to date."
