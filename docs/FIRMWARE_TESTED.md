# Firmware Tested

## Overview

This document lists all firmware versions tested during the investigation.

Only firmware versions that have been personally verified are included.

---

# Tested Cameras

The following camera models have been tested:

| Model | Lens |
|-------|------|
| HWI-B140H | 2.8 mm |
| HWI-B140H | 4 mm |

---

# Firmware Test Results

| Firmware Version | Release Date | Result | Notes |
|-----------------|--------------|--------|------|
| V5.7.23_241211 | 2024-12-11 | ❌ Bug Present | Scheduled profile switching does not reload ISP parameters. |
| V5.7.25_260401 | 2026-04-01 | ❌ Bug Present | Behaviour identical to previous firmware. |

---

# Test Procedure

Each firmware version was tested using the same procedure.

The cameras were configured with:

- Monthly profile scheduling enabled
- Separate Day and Night image profiles
- Factory default image settings unless otherwise noted
- Automatic transition from Night to Day

The behaviour was then observed during the scheduled profile transition.

---

# Observed Behaviour

For every tested firmware version:

✔ GUI correctly reports profile change.

✔ Scheduler remains active.

✔ Manual profile switching works correctly.

❌ Automatic scheduler fails to reload ISP parameters.

❌ Daylight image remains overexposed.

---

# Firmware Upgrade Verification

After every firmware update:

- Camera rebooted successfully.
- Configuration preserved.
- ISAPI interface remained fully functional.
- Workaround script continued to operate correctly.

No differences were observed regarding the scheduler bug.

---

# Future Testing

This document will be updated whenever a new firmware version becomes available.

If Hikvision releases a firmware fixing this issue, the corresponding version will be marked accordingly.

Example:

| Firmware | Result |
|-----------|--------|
| Vx.x.xx | ✅ Bug Fixed |

---

# Current Status

Latest firmware tested:

**V5.7.25_260401**

Result:

**Bug still present.**
