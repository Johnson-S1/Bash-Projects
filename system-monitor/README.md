# System Health Monitoring Script

This script monitors basic system health parameters such as CPU, memory, disk usage, and service status. It logs the results and helps identify potential issues in the system.

## Features

- CPU usage monitoring
- Memory usage monitoring
- Disk usage monitoring (all mounted filesystems)
- Service status checks
- Threshold-based alerts (OK / WARNING / CRITICAL)
- Logging with timestamps

## How it Works

The script collects system metrics and compares them against defined thresholds. Based on the values, it categorizes the system state and logs the output.

## Usage

```bash

chmod +x health.sh
./health.sh

## Sample Output

2026-02-23 22:14:53 | ############ Health Check Started ############
2026-02-23 22:14:53 | CPU is HEALTHY: 5%
2026-02-23 22:14:53 | Mem is HEALTHY: 46%
2026-02-23 22:14:53 | filesystem / is HEALTHY: 51%

## Note

- Threshold values can be modified inside the script or config file.
- Designed to be used with cron for periodic monitoring.
