# Changelog

All notable changes to AIAnalyticsKit are documented here.

This project follows [Semantic Versioning](https://semver.org) and the [Keep a Changelog](https://keepachangelog.com) format.

---

## [Unreleased]

---

## [1.0.0] — 2026-03-26

### Added
- Firebase-style static facade `AIAnalytics.logEvent()` and `AIAnalytics.logScreenView()` — fire-and-forget event logging from any file or actor
- `.aiAnalytics()` SwiftUI view modifier — one-line setup that wires the full object graph into the environment
- `HomeViewModel` — `@Observable @MainActor` orchestrator running the full prediction pipeline (track → features → predict → personalize)
- `HomeView` — ready-to-use SwiftUI component with adaptive greeting, accent color, recommended actions, and on-device privacy badge
- `FoundationPredictionEngine` — on-device inference via `SystemLanguageModel(.general)` with deterministic heuristic fallback
- `SwiftDataEventStore` — `@ModelActor` persistent event store backed by SQLite; falls back to in-memory store on failure
- `FeatureBuilder` — extracts a 6-dimension feature vector (total events, unique screens, error rate, analysis count, session duration, account age)
- `ClassificationConfig` — single source of truth for all classification thresholds and confidence values
- `PersonalizationEngine` — maps `UserPrediction` to `UIConfiguration` (greeting, accent color, feature visibility, recommended actions)
- `UIConfiguration` — personalization payload with `showAdvancedFeatures` toggle and typed `RecommendedAction` list
- `UserType` — four user segments: Power User, Casual User, Explorer, At-Risk
- `UserPrediction` — typed prediction result with confidence score (0.0–1.0, auto-clamped) and timestamp
- `HomeViewState` — explicit value-type enum (`idle / loading / ready / failure`) driving all UI transitions
- Reusable UI components: `CardContainer`, `SectionHeader`, `ErrorBanner`
- Swift 6 strict concurrency throughout (`.swiftLanguageMode(.v6)`)
- iOS 26.0+ and macOS 26.0+ support
- Comprehensive demo app (`AIAnalyticsKitDemo`) with 7 screens

---

[Unreleased]: https://github.com/saurabhdave/AIAnalyticsKit/compare/1.0.0...HEAD
[1.0.0]: https://github.com/saurabhdave/AIAnalyticsKit/releases/tag/1.0.0
