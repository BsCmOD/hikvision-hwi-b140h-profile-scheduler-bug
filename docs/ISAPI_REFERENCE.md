# ISAPI Reference

## Overview

This document describes the Hikvision ISAPI endpoints used by the workaround.

Only officially exposed ISAPI interfaces are used.

No undocumented endpoints or firmware modifications are required.

---

# Authentication

The camera uses HTTP Digest Authentication.

Example:

```
curl --digest -u username:password http://CAMERA_IP/...
```

---

# Endpoint 1

## Display Parameter Scheduler

```
PUT /ISAPI/Image/channels/1/displayParamSwitch
```

### Purpose

Enables, disables or configures the automatic image profile scheduler.

---

### Modes

| Mode | Description |
|------|-------------|
| disable | Scheduler disabled |
| month | Monthly schedule enabled |

---

### Used by the workaround

The workaround temporarily disables the scheduler before forcing the profile reload.

---

# Endpoint 2

## Mounting Scenario

```
PUT /ISAPI/Image/channels/1/mountingScenario
```

### Purpose

Changes the active image profile.

---

### Available modes

| Mode | Description |
|------|-------------|
| normal | Day profile |
| lowIllumination | Night profile |

---

### Used by the workaround

The workaround intentionally performs:

```
lowIllumination
↓

normal
```

This sequence forces the camera to reload the ISP parameters.

---

# Typical Sequence

The complete workaround performs the following ISAPI requests.

```
displayParamSwitch
        │
        ▼
mode = disable
        │
        ▼
mountingScenario
        │
        ▼
lowIllumination
        │
        ▼
mountingScenario
        │
        ▼
normal
        │
        ▼
displayParamSwitch
        │
        ▼
restore monthly schedule
```

---

# Timing

Several delays are intentionally inserted between requests.

The firmware requires time to internally apply each configuration change before receiving the next command.

Removing these delays may reduce reliability.

---

# XML Payloads

The repository script contains complete XML examples for:

- disabling the scheduler;
- selecting the Low Illumination profile;
- selecting the Normal profile;
- restoring the monthly schedule.

Keeping the XML inside the script makes it easier to adapt the workaround to different environments.

---

# Compatibility

Verified on:

- HWI-B140H (2.8 mm)
- HWI-B140H (4 mm)

Firmware:

- V5.7.23_241211
- V5.7.25_260401

---

# Notes

This document only describes the ISAPI commands actually required by the workaround.

Other Hikvision ISAPI endpoints are outside the scope of this project.
