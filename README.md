# Hikvision HWI-B140H Profile Scheduler Bug

> [!WARNING]
> **Firmware bug confirmed**
>
> This repository documents a reproducible firmware issue affecting Hikvision HWI-B140H network cameras where the scheduled Day/Night image profile switching changes the active profile shown in the web interface but fails to apply the corresponding ISP (Image Signal Processor) parameters.

> [!IMPORTANT]
> This project **does not modify or patch the camera firmware**.
>
> The provided workaround only uses **official Hikvision ISAPI commands** to force the camera to correctly reload the image processing pipeline.

---

# Overview

Several Hikvision HWI-B140H cameras expose a firmware issue affecting the scheduled image profile switching feature.

When the camera automatically switches from **Night profile** to **Day profile** according to the configured schedule, the web interface correctly reports that the Day profile is active.

However, the camera internally continues using the previous Night profile ISP parameters, producing heavily overexposed images during daylight.

The issue has been reproduced multiple times on different firmware versions, including the latest firmware available at the time this repository was created.

The repository includes an example monthly scheduler XML under the examples/ directory. Do not use it as-is; adapt the schedule to your local sunrise and sunset times.

---

# Affected Models

Currently verified on:

- Hikvision HWI-B140H (2.8 mm)
- Hikvision HWI-B140H (4 mm)

Other models may also be affected but have not been tested.

---

# Tested Firmware

| Firmware | Result |
|-----------|--------|
| V5.7.23_241211 | ❌ Bug present |
| V5.7.25_260401 | ❌ Bug still present |

More detailed firmware information is available in:

- docs/FIRMWARE_TESTED.md

---

# Symptoms

Typical symptoms include:

- Scheduled profile switching appears to work.
- Web interface shows the correct active profile.
- Image remains heavily overexposed after sunrise.
- Exposure, gain and shutter values are still those of the Night profile.
- Manually changing the profile immediately fixes the image.

---

# Expected Behaviour

```
Scheduler
      │
      ▼
Switch to Day profile
      │
      ▼
Reload ISP parameters
      │
      ▼
Correct daylight exposure
```

---

# Actual Behaviour

```
Scheduler
      │
      ▼
GUI switches to Day profile
      │
      ▼
ISP parameters remain unchanged
      │
      ▼
Night exposure still active
      │
      ▼
Overexposed daylight image
```

---

# Workaround

A reliable workaround has been identified using Hikvision's official ISAPI interface.

The workaround performs the following sequence:

1. Disable the automatic profile scheduler.
2. Force **Low Illumination** mode.
3. Force **Normal** mode.
4. Restore the original schedule.

This forces the camera to correctly reload the internal ISP parameters.

The complete automation script is available under:

```
script/sblocco_camere.sh
```

---

# Repository Structure

```
docs/
    BUG_DESCRIPTION.md
    FIRMWARE_TESTED.md
    HOW_IT_WORKS.md
    INSTALLATION.md
    ISAPI_REFERENCE.md
    TROUBLESHOOTING.md

script/
    monthly_schedule_example.xml
    sblocco_camere.sh
```

---

# Documentation

Detailed documentation is available in:

- Bug description
- Firmware testing
- Installation guide
- ISAPI reference
- Troubleshooting
- Internal workaround explanation

---

# Disclaimer

This repository is an independent technical documentation project.

It is **not affiliated with or endorsed by Hikvision**.

All product names, trademarks and registered trademarks belong to their respective owners.

The workaround only uses publicly available Hikvision ISAPI commands and does **not** modify or reverse engineer the camera firmware.

---

# License

This project is released under the MIT License.
