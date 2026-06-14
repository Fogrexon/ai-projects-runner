#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="ai-projects-runner.service"
SYSTEMD_USER_DIR="${HOME}/.config/systemd/user"
SERVICE_PATH="${SYSTEMD_USER_DIR}/${SERVICE_NAME}"

if [[ ! -x "${ROOT_DIR}/.runner/run.sh" ]]; then
  echo "Runner is not configured at ${ROOT_DIR}/.runner." >&2
  echo "Run ./scripts/download-runner.sh and ./scripts/configure-runner.sh first." >&2
  exit 1
fi

mkdir -p "$SYSTEMD_USER_DIR"

cat > "$SERVICE_PATH" <<SERVICE
[Unit]
Description=GitHub Actions self-hosted runner for Fogrexon/ai-projects
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=${ROOT_DIR}/.runner
ExecStart=${ROOT_DIR}/.runner/run.sh
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
SERVICE

systemctl --user daemon-reload
systemctl --user enable "$SERVICE_NAME"

cat <<MSG
Installed ${SERVICE_NAME}.

To avoid running two runner processes, stop any manual ./run.sh session first.
Then start the service with:

  systemctl --user start ${SERVICE_NAME}

Check status with:

  systemctl --user status ${SERVICE_NAME}

To start at boot before this user logs in, enable lingering once:

  sudo loginctl enable-linger ${USER}
MSG

