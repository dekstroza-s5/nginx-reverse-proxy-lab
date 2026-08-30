#!/usr/bin/env bash
set -euo pipefail
base="${1:-http://localhost:8080}"
curl --fail "$base/health"
for _ in $(seq 1 10); do curl --fail --silent "$base/" >/dev/null; done
echo "smoke test passed"
