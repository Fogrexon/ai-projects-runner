#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

RUNNER_VERSION="${RUNNER_VERSION:-2.335.1}"
RUNNER_SHA256="${RUNNER_SHA256:-4ef2f25285f0ae4477f1fe1e346db76d2f3ebf03824e2ddd1973a2819bf6c8cf}"
RUNNER_ARCHIVE="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_ARCHIVE}"

mkdir -p .runner
cd .runner

if [[ ! -f "$RUNNER_ARCHIVE" ]]; then
  curl -L -o "$RUNNER_ARCHIVE" "$RUNNER_URL"
fi

echo "${RUNNER_SHA256}  ${RUNNER_ARCHIVE}" | shasum -a 256 -c
tar xzf "$RUNNER_ARCHIVE"

echo "Runner downloaded into ${ROOT_DIR}/.runner"

