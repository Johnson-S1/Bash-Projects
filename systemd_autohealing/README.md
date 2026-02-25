# Log-Based Service Auto Recovery Script

This script monitors systemd journal logs for specific failure patterns and automatically recovers services when issues are detected.

## Features

- Log parsing using journalctl
- Pattern-based failure detection (e.g., failed to start, segfault)
- Automatic service restart or start
- Cooldown mechanism to avoid restart loops
- Timestamp-based logging

## How it Works

The script checks recent logs for a service. If a failure pattern is detected, it verifies the current service state and performs recovery actions accordingly.

A cooldown timer ensures that services are not restarted repeatedly within a short time.

## Usage

```bash
chmod +x service_recovery.sh
./service_recovery.sh

## Example Logic

- If service is running → restart
- If service is stopped → start
- If cooldown active → skip restart

## Sample Log

2026-02-24 21:49:52 | ----- Checking sshd logs -----
2026-02-24 21:49:52 | no issue detected
2026-02-24 22:02:22 | ----- Checking sshd logs -----
2026-02-24 22:02:22 | Failure pattern detected in logs
2026-02-24 22:02:22 | Restarting sshd due to detected issue

## Notes

- Works with systemd-based systems
- Failure patterns can be customized
- Designed for automation and self-healing systems
