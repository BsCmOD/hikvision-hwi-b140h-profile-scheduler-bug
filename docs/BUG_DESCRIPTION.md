# Bug Description

## Overview

This document describes a reproducible firmware issue affecting Hikvision HWI-B140H network cameras when using the built-in scheduled image profile switching feature.

The issue has been reproduced on multiple cameras, multiple firmware versions and under different system configurations.

The problem specifically affects the automatic transition from the **Night** profile to the **Day** profile.

---

# Affected Feature

Image → Display Parameters → Scheduled Profile Switching

The camera allows configuring different image profiles (Normal / Low Illumination) according to a daily or monthly schedule.

This feature is intended to automatically switch image parameters depending on ambient lighting conditions.

---

# Expected Behaviour

When the configured schedule reaches the transition time:

1. The active profile changes from **Night** to **Day**.
2. The camera reloads the corresponding ISP (Image Signal Processor) parameters.
3. Exposure, gain, shutter and all related image parameters are updated.
4. The resulting image is correctly exposed for daylight.

---

# Actual Behaviour

At the scheduled transition time:

1. The web interface correctly reports that the active profile has changed.
2. The scheduled configuration remains valid.
3. The camera **does not reload the ISP parameters** associated with the selected profile.
4. Image processing continues using the previous Night profile parameters.

As a consequence:

- daylight images become heavily overexposed;
- exposure values remain inconsistent with the selected profile;
- manually selecting another profile immediately restores correct behaviour.

---

# Symptoms

The issue is easily recognizable because:

- The web interface indicates that the Day profile is active.
- Image quality clearly corresponds to the Night profile.
- Bright daylight scenes appear severely overexposed.
- The problem remains until the image profile is manually changed.

---

# Conditions Required to Reproduce

The issue can be reproduced using the following configuration:

- Scheduled image profile switching enabled.
- Separate Day and Night image profiles configured.
- Automatic transition from Night → Day.

No special configuration is required.

---

# Reproducibility

The issue has been reproduced:

- on multiple HWI-B140H cameras;
- using different firmware releases;
- after factory reset;
- after manual reconfiguration;
- after firmware upgrades;
- with direct camera access through the web interface;
- through Hikvision NVR Virtual Host.

The behaviour remains identical in all tested scenarios.

---

# Temporary Workaround

A reliable workaround has been identified.

Instead of manually changing the image profile every morning, the camera can be forced to correctly reload the ISP parameters using official Hikvision ISAPI commands.

The workaround performs the following sequence:

1. Disable the scheduled profile switching.
2. Force **Low Illumination** mode.
3. Force **Normal** mode.
4. Restore the original schedule.

This sequence consistently restores the correct Day profile image parameters.

The implementation is documented in:

- HOW_IT_WORKS.md
- ISAPI_REFERENCE.md

---

# Root Cause (Hypothesis)

Based on extensive testing, the most likely explanation is that the firmware correctly updates the logical profile state shown in the user interface but does not trigger a complete reload of the internal ISP/image processing pipeline.

This hypothesis is supported by the fact that manually forcing a profile transition through ISAPI immediately restores correct image behaviour without requiring a reboot.

Since Hikvision has not publicly documented the internal implementation of the scheduler, this should be considered an engineering hypothesis based on observed behaviour.

---

# Scope

At the time of writing, this issue has only been verified on:

- Hikvision HWI-B140H (2.8 mm)
- Hikvision HWI-B140H (4 mm)

Other camera models have not been tested.

---

# Status

**Current status:** OPEN

Latest tested firmware:

- V5.7.25_260401

Result:

**Bug still present.**

## Notes

This document intentionally focuses only on observed and reproducible behaviour.

No assumptions are made regarding the internal firmware implementation beyond what has been experimentally verified.
