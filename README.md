# ai-projects Runner

Local GitHub Actions self-hosted runner management for:

```text
https://github.com/Fogrexon/ai-projects
```

This repository intentionally tracks only setup scripts and documentation. The
GitHub runner binary, `_work` checkout directory, logs, and registration secrets
live under `.runner/` and are ignored by git.

## Setup

1. Copy the environment template:

   ```bash
   cp .env.example .env
   ```

2. Open GitHub:

   ```text
   Repository Settings -> Actions -> Runners -> New self-hosted runner
   ```

3. Put the generated token into `.env` as `RUNNER_TOKEN`.

4. Download and verify the runner:

   ```bash
   ./scripts/download-runner.sh
   ```

5. Configure the runner:

   ```bash
   ./scripts/configure-runner.sh
   ```

6. Start it:

   ```bash
   ./scripts/run-runner.sh
   ```

The runner must include this label so the workflow in `ai-projects` can pick it:

```text
ai-projects-local-codex
```

## Notes

- Keep `.env` private. Runner registration tokens are short-lived secrets.
- Run this from a trusted local machine where `codex` is installed and logged in.
- The `ai-projects` workflow uses system Chrome for Playwright through
  `PLAYWRIGHT_BROWSER_CHANNEL=chrome`, which avoids the Chromium download issue
  on Ubuntu 26.04.
- If you reconfigure the runner, remove or recreate `.runner/` locally. Do not
  commit it.

## Optional systemd

Use `systemd/ai-projects-runner.service.example` as a starting point if you want
the runner to start on login or boot. Adjust `User`, `WorkingDirectory`, and
paths before installing it.

