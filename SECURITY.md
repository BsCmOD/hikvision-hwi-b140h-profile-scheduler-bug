# Security Policy

## Supported Versions

This repository documents a firmware issue and provides a Bash workaround.

The latest version available in the repository is considered the supported version.

| Version | Supported |
|----------|-----------|
| 1.x | ✅ Yes |
| < 1.0 | ❌ No |

---

## Reporting a Security Issue

If you discover a security issue related to:

- The workaround script
- Sensitive information accidentally committed to the repository
- Unsafe implementation details

please open a GitHub Issue describing the problem.

If the issue contains sensitive information that should not be publicly disclosed, please contact the repository owner privately before opening a public report.

---

## Scope

This repository does **not** contain:

- Modified Hikvision firmware
- Exploits
- Reverse-engineered firmware components
- Authentication bypass techniques

The workaround uses only officially documented Hikvision ISAPI commands.

---

## Credentials

Never publish:

- Real IP addresses
- Public IP addresses
- Camera passwords
- NVR passwords
- API credentials
- Sensitive network information

Always replace them with placeholder values before opening an Issue or Pull Request.

Example:

```text
NVR_IP="YOUR_NVR_IP"
CAMERA_USER="YOUR_USERNAME"
CAMERA_PASSWORD="YOUR_PASSWORD"
```

---

## Disclaimer

This project is provided for educational and troubleshooting purposes.

Always test the workaround in a controlled environment before deploying it in production.
