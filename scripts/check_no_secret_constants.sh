#!/usr/bin/env bash
set -euo pipefail

# Blocks obvious committed secret-like literals inside lib/.
if rg -n "(sk_(test|live)_[A-Za-z0-9]+|rk_(test|live)_[A-Za-z0-9]+|stripeSecretKey\s*=|api[_-]?key\s*=\s*['\"][A-Za-z0-9_\-]{20,}['\"]|client_secret\s*=\s*['\"][^'\"]+['\"])" lib; then
  echo "❌ Secret-like constant detected in lib/. Move secrets to backend/secure config."
  exit 1
fi

echo "✅ No obvious secret-like constants found in lib/."
