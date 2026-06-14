#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f .env ]]; then
  echo "Missing .env. Copy .env.example to .env and set RUNNER_TOKEN." >&2
  exit 1
fi

set -a
# shellcheck disable=SC1091
source .env
set +a

: "${GITHUB_REPOSITORY_URL:?GITHUB_REPOSITORY_URL is required}"
: "${RUNNER_TOKEN:?RUNNER_TOKEN is required}"

RUNNER_LABELS="${RUNNER_LABELS:-ai-projects-local-codex}"
RUNNER_NAME="${RUNNER_NAME:-ai-projects-local-codex}"

if [[ ! -x .runner/config.sh ]]; then
  echo "Runner is not downloaded. Run ./scripts/download-runner.sh first." >&2
  exit 1
fi

cd .runner
./config.sh \
  --url "$GITHUB_REPOSITORY_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --work "_work"

