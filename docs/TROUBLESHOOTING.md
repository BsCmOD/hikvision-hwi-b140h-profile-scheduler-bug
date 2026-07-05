# Troubleshooting

## Overview

This document provides guidance for diagnosing and resolving common issues encountered while using the workaround.

The checks below assume that the workaround script has been configured correctly.

---

# The Script Does Nothing

## Symptoms

The script executes without errors but the camera image does not change.

## Possible Causes

- Current time does not match the configured schedule.
- Cron has not executed the script.
- Camera is unreachable.
- Incorrect IP address or port.

## Recommended Checks

Verify current system time:

```bash
date
```

Verify Raspberry Pi time synchronization:

```bash
timedatectl
```

Run the script manually:

```bash
./script/sblocco_camere.sh
```

---

# Authentication Failed

## Symptoms

HTTP authentication errors.

Example:

```
401 Unauthorized
```

## Possible Causes

- Wrong username.
- Wrong password.
- Digest authentication disabled.
- Incorrect camera account.

## Recommended Checks

Verify credentials by executing:

```bash
curl --digest -u USER:PASS http://CAMERA_IP/ISAPI/System/deviceInfo
```

---

# Camera Does Not Respond

## Symptoms

curl timeout.

Connection refused.

No response.

## Recommended Checks

Verify network connectivity.

```bash
ping CAMERA_IP
```

Verify Virtual Host port.

Verify firewall rules.

Verify that ISAPI is enabled.

---

# Scheduler Is Not Restored

## Symptoms

Automatic profile switching remains disabled.

## Possible Causes

The final XML request failed.

## Recommended Checks

Inspect the XML payload.

Verify the HTTP response.

Confirm that the scheduler is enabled from the web interface.

---

# Image Remains Overexposed

## Symptoms

The workaround completes successfully but daylight exposure remains incorrect.

## Recommended Checks

Verify that:

- Low Illumination is actually selected.
- Normal profile is correctly applied.
- Delays between requests are sufficient.
- Camera has completed processing each request.

Increasing the delay between requests may improve reliability.

---

# Cron Does Not Execute

## Symptoms

The workaround never runs automatically.

## Verify Cron

List cron jobs:

```bash
crontab -l
```

Verify cron service:

```bash
sudo systemctl status cron
```

Review system log:

```bash
grep CRON /var/log/syslog
```

---

# ISAPI Commands Fail

## Symptoms

HTTP errors.

Unexpected XML responses.

## Recommended Checks

Confirm that:

- the endpoint exists on your firmware;
- the camera supports the required ISAPI functions;
- the XML syntax is valid.

---

# Firmware Update

After every firmware update verify:

- Scheduler behaviour.
- ISAPI compatibility.
- XML payload compatibility.
- Workaround functionality.

Even if the firmware version changes, avoid assuming the issue has been fixed without testing.

---

# Before Opening an Issue

Please verify the following:

- Camera model.
- Firmware version.
- Script version.
- Raspberry Pi OS version.
- Manual execution result.
- Cron configuration.
- Network connectivity.
- Authentication.

Including this information significantly speeds up troubleshooting.

---

# Still Having Problems?

If you believe you have found a different behaviour:

- Include the camera model.
- Include the firmware version.
- Describe the expected behaviour.
- Describe the observed behaviour.
- Include any ISAPI responses if available.

Please avoid posting passwords, IP addresses or sensitive information.
