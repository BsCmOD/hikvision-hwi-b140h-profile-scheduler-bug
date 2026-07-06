# Changelog

All notable changes to this project will be documented in this file.

The format is based on the principles of
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows Semantic Versioning.

---

## [1.0.0] - 2026-07-06

### Added

- Initial public release.
- Documentation of the HWI-B140H scheduled profile switching firmware bug.
- Description of the root cause and observed behavior.
- ISAPI command reference used during the investigation.
- Raspberry Pi workaround script.
- Installation guide.
- Troubleshooting guide.
- Firmware compatibility table.
- Example monthly scheduler XML configuration.
- MIT License.

### Tested

- HWI-B140H (HiWatch)
- Firmware V5.7.25 Build 260401

### Notes

This release documents a firmware issue where scheduled image profile changes
(Day/Night switching) do not correctly reload the ISP parameters.

The included workaround relies exclusively on official Hikvision ISAPI
commands and does not modify the camera firmware.
