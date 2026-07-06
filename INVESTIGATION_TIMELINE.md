# Investigation Timeline

This document summarizes the investigation process that led to the identification of the firmware issue and the development of the workaround.

---

## Initial Symptoms

The cameras were configured to switch automatically between image profiles using the built-in monthly scheduler.

The scheduler changed the active profile at the configured time, but the image parameters remained unchanged.

Although the web interface reported the new profile as active, the camera continued using the previous ISP configuration.

---

## Initial Assumptions

Several possible causes were investigated:

- Incorrect scheduler configuration.
- Browser caching.
- NVR Virtual Host issues.
- Configuration not properly saved.
- Camera reboot required after configuration changes.

None of these explained the behavior.

---

## Firmware Comparison

Multiple firmware versions were tested.

The issue was consistently reproduced after every scheduled profile change.

Updating to newer firmware versions did not resolve the problem.

---

## Manual Testing

Changing the image profile manually from the web interface immediately restored the correct ISP parameters.

This demonstrated that:

- the image profiles were correctly configured;
- the ISP parameters were valid;
- only the automatic scheduler failed.

---

## ISAPI Investigation

The Hikvision ISAPI interface was used to reproduce every operation performed by the web interface.

Several endpoints were tested, including:

- Profile selection
- Scheduler configuration
- Image settings
- Mounting Scenario

The behavior was reproduced entirely through ISAPI.

---

## Root Cause

The investigation showed that the scheduler correctly changes the active profile, but fails to reload the corresponding ISP configuration.

As a result:

- the profile name changes;
- the internal ISP parameters remain unchanged;
- image quality is therefore incorrect.

The issue appears to be entirely firmware-related.

---

## Workaround Development

A workaround was developed using only official Hikvision ISAPI commands.

The sequence is:

1. Disable the profile scheduler.
2. Force the **Low Illumination** profile.
3. Force the **Normal** profile.
4. Restore the original monthly scheduler.

This forces the firmware to reload the ISP parameters correctly.

---

## Long-Term Testing

The workaround has been tested for several weeks on a Raspberry Pi using a scheduled Bash script.

Results:

- Stable operation.
- No unexpected side effects observed.
- Correct profile switching every day.
- Fully automatic recovery after each scheduled transition.

---

## Vendor Contact

The issue was reported to Hikvision technical support.

Firmware updates released during the investigation were tested but did not resolve the problem.

At the time of writing, the firmware bug is still present.

---

## Conclusion

The workaround documented in this repository is currently the most reliable solution found.

It does not modify the firmware and relies exclusively on officially supported Hikvision ISAPI commands.

The repository will be updated if Hikvision releases a firmware version that permanently fixes the issue.
