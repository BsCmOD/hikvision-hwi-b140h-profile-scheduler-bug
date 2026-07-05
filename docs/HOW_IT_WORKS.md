# How the Workaround Works

## Introduction

This document explains the logic behind the workaround implemented in `script/sblocco_camere.sh`.

The workaround does **not** modify the camera firmware.

Instead, it forces the camera to correctly reload the internal Image Signal Processor (ISP) parameters by using official Hikvision ISAPI endpoints.

---

# The Problem

During normal scheduled operation the camera performs the following sequence:

```
Scheduler
        │
        ▼
Switch GUI profile
        │
        ▼
GUI shows "Normal"
        │
        ▼
ISP parameters remain "Low Illumination"
        │
        ▼
Overexposed daylight image
```

The graphical interface reports that the profile has changed correctly, but the image processing pipeline continues using the previous profile.

---

# The Workaround

The workaround forces the firmware to reload the internal image pipeline.

The following sequence is executed.

```
Disable Scheduler
        │
        ▼
Force Low Illumination
        │
        ▼
Force Normal
        │
        ▼
Restore Scheduler
```

This sequence consistently restores the correct ISP parameters.

---

# Why Disable the Scheduler?

The first step temporarily disables the automatic profile scheduler.

This guarantees that no scheduled event interferes with the forced profile changes while the workaround is running.

---

# Why Force Low Illumination First?

Although the camera is already operating with Night profile parameters, explicitly forcing the `lowIllumination` mounting scenario guarantees that the firmware receives a complete profile change request.

This prepares the camera for the following transition.

---

# Why Force Normal?

Changing from

```
lowIllumination
```

to

```
normal
```

appears to trigger a complete reload of the internal ISP configuration.

Immediately after this operation:

- exposure becomes correct;
- gain values change correctly;
- shutter parameters are updated;
- daylight image becomes properly exposed.

---

# Why Restore the Scheduler?

The workaround is intended to be completely transparent.

After the ISP parameters have been correctly reloaded, the original monthly schedule is restored exactly as it was before.

The camera therefore continues operating with its normal automatic scheduling.

---

# Timing Considerations

Several seconds are intentionally inserted between ISAPI requests.

The camera requires enough time to internally process each configuration change before receiving the next command.

Reducing these delays may result in inconsistent behaviour.

---

# ISAPI Commands Used

The workaround only uses official Hikvision ISAPI endpoints.

Main endpoints:

```
PUT /ISAPI/Image/channels/1/displayParamSwitch
```

```
PUT /ISAPI/Image/channels/1/mountingScenario
```

No undocumented APIs are used.

---

# Why This Works

The exact internal firmware implementation is not publicly documented.

However, extensive testing strongly suggests that manually forcing a complete profile transition causes the firmware to reload the ISP pipeline correctly.

This behaviour is consistently reproducible.

---

# Reliability

The workaround has been tested on:

- multiple HWI-B140H cameras;
- multiple firmware versions;
- multiple consecutive day/night cycles.

During testing the workaround consistently restored the correct daylight profile.

---

# Limitations

This workaround should be considered a temporary solution.

It does not permanently fix the firmware bug.

An official firmware update from Hikvision would still be the preferred solution.

---

# Summary

```
Firmware scheduler
        │
        ▼
Profile changes
        │
        ▼
ISP does NOT reload
        │
        ▼
Bug
```

↓

```
ISAPI workaround
        │
        ▼
Force profile transition
        │
        ▼
ISP reload
        │
        ▼
Correct image
```
