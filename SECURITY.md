# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | ✅        |

## Privacy Model

AIAnalyticsKit is designed with privacy as a core constraint, not an afterthought:

- **No network calls** — the library makes zero outbound network requests. All inference runs on-device via Apple's Foundation Models framework.
- **No data egress** — user behavior events never leave the device. There is no analytics backend, no third-party SDK, and no telemetry.
- **SwiftData persistence** — events are stored in the app's private SwiftData container, protected by the iOS/macOS sandbox. No data is written outside the app's container.
- **On-device inference** — classification runs on Apple's Neural Engine using `SystemLanguageModel(.general)`. No data is sent to Apple's servers as part of this library's usage.

## Reporting a Vulnerability

If you discover a security or privacy vulnerability in AIAnalyticsKit, **please do not open a public GitHub issue**.

Instead, report it by emailing the maintainer directly (see the repository owner's GitHub profile for contact details). Include:

- A description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested mitigations

You can expect an acknowledgement within 48 hours and a resolution or status update within 14 days.

We will credit reporters in the release notes unless you prefer to remain anonymous.
