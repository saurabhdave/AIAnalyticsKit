# Contributing to AIAnalyticsKit

Thank you for taking the time to contribute. This guide covers everything you need to get started.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Messages](#commit-messages)
- [Changelog](#changelog)
- [Releasing](#releasing)

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold it.

---

## Getting Started

1. **Search existing issues** before opening a new one — your question or bug may already be tracked.
2. For bugs, use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md).
3. For new features, open a [feature request](.github/ISSUE_TEMPLATE/feature_request.md) first to discuss the approach before writing code.

---

## How to Contribute

1. Fork the repository
2. Create a branch from `main`:
   ```bash
   git checkout -b fix/my-bug-fix
   # or
   git checkout -b feat/my-new-feature
   ```
3. Make your changes (see [Coding Standards](#coding-standards))
4. Update [CHANGELOG.md](CHANGELOG.md) under `[Unreleased]`
5. Open a pull request against `main` using the provided template

---

## Development Setup

**Requirements:** Xcode 26+, Swift 6.0, iOS 26 Simulator

```bash
# Clone your fork
git clone https://github.com/your-fork/AIAnalyticsKit.git
cd AIAnalyticsKit

# Build the library
swift build

# Run tests
swift test

# Build the demo app
xcodebuild \
  -project Examples/AIAnalyticsKitDemo/AIAnalyticsKitDemo.xcodeproj \
  -scheme AIAnalyticsKitDemo \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build
```

---

## Coding Standards

- **Swift 6 strict concurrency** — all code must compile cleanly with `-strict-concurrency=complete`. No `nonisolated(unsafe)` without a documented reason.
- **Actor isolation** — `AnalyticsManager` and `SwiftDataEventStore` are actors; respect their isolation boundaries.
- **Protocol-first** — new capabilities should be introduced behind a protocol (`AIEngine`, `EventStore`, `FeatureBuilding`, `PersonalizationEngineProtocol`) so they can be swapped or mocked.
- **No external dependencies** — the library uses only Apple frameworks (`FoundationModels`, `SwiftData`, `SwiftUI`, `OSLog`). Do not add third-party packages.
- **Graceful degradation** — every engine or store that can fail must have a working fallback.
- **Minimal surface area** — mark new types `internal` unless there is a clear reason to make them `public`.

---

## Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org):

```
<type>: <short description>

[optional body]

[optional footer]
```

| Type       | When to use                                    |
|------------|------------------------------------------------|
| `feat`     | New feature or public API addition             |
| `fix`      | Bug fix                                        |
| `docs`     | Documentation only                             |
| `refactor` | Code change with no behavior change            |
| `test`     | Adding or updating tests                       |
| `chore`    | Build, CI, dependency, or config changes       |
| `perf`     | Performance improvement                        |

Breaking changes must include `BREAKING CHANGE:` in the footer and a `!` after the type (e.g. `feat!:`).

---

## Changelog

Every pull request that changes behavior, the public API, or fixes a bug must include a corresponding entry in [CHANGELOG.md](CHANGELOG.md) under `[Unreleased]`.

Format:

```markdown
## [Unreleased]

### Added
- Short description of what was added

### Changed
- Short description of what changed (and why, if non-obvious)

### Fixed
- Short description of what was fixed

### Removed
- Short description of what was removed
```

---

## Releasing

> Only maintainers perform releases.

1. Move all `[Unreleased]` entries in `CHANGELOG.md` to a new version section:
   ```markdown
   ## [1.1.0] — YYYY-MM-DD
   ```
2. Update the diff links at the bottom of `CHANGELOG.md`
3. Commit: `chore: release 1.1.0`
4. Tag and push:
   ```bash
   git tag 1.1.0
   git push origin main 1.1.0
   ```
5. The [release workflow](.github/workflows/release.yml) creates the GitHub Release automatically and extracts the changelog entry as the release notes.
