# Installation

## Overview

This guide explains how to deploy the workaround using a Raspberry Pi.

The same procedure can also be adapted to any Linux system capable of executing Bash scripts and `curl`.

---

# Requirements

## Hardware

- Raspberry Pi (any modern model)
- Network connectivity to the camera or NVR
- Cameras supporting Hikvision ISAPI

---

## Software

- Raspberry Pi OS or any Linux distribution
- Bash
- curl
- cron

Verify that curl is installed:

```bash
curl --version
```

---

# Network Requirements

The Raspberry Pi must be able to communicate with the cameras.

This can be achieved by:

- Direct access to the camera IP address
- Hikvision NVR Virtual Host ports

Example:

```
192.168.1.253:65001
192.168.1.253:65002
...
```

---

# Download

Clone the repository:

```bash
git clone https://github.com/<YOUR_USERNAME>/hikvision-hwi-b140h-profile-scheduler-bug.git
```

Enter the project:

```bash
cd hikvision-hwi-b140h-profile-scheduler-bug
```

---

# Configure the Script

Edit:

```
script/sblocco_camere.sh
```

Modify the following parameters:

```bash
NVR_IP="192.168.1.253"
USER="YOUR_USER"
PASS="YOUR_PASSWORD"

PORTE=(65001 65002 65003 65004 65005 65006)
```

Adjust the monthly schedule according to your installation.

---

# Test the Script

Before enabling automation, execute the script manually.

```bash
chmod +x script/sblocco_camere.sh
```

Run:

```bash
./script/sblocco_camere.sh
```

Verify that:

- the script completes without errors;
- image profiles change correctly;
- daylight exposure is restored.

---

# Automatic Execution

Edit the user crontab:

```bash
crontab -e
```

Example:

```cron
*/10 * * * * /home/pi/hikvision-hwi-b140h-profile-scheduler-bug/script/sblocco_camere.sh > /dev/null 2>&1
```

The script will silently execute every ten minutes.

Internally it checks whether the current time matches the configured transition time.

If not, it immediately exits without performing any operation.

---

# Verification

After installation verify:

- Raspberry Pi system time is correct.
- Camera time is correct.
- NTP synchronization is enabled.
- Scheduler configuration matches the XML contained in the script.

---

# Updating the Script

Future improvements can simply be obtained by pulling the latest repository version.

```bash
git pull
```

---

# Security Notes

For production environments it is recommended to:

- use a dedicated camera account whenever possible;
- restrict Raspberry Pi network access;
- protect stored credentials;
- periodically back up the script and configuration.

---

# Troubleshooting

If the workaround does not execute correctly, refer to:

- TROUBLESHOOTING.md

For ISAPI endpoint details, refer to:

- ISAPI_REFERENCE.md
