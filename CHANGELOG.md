# Changelog

All notable changes to AIAnalyticsKit are documented here.

This project follows [Semantic Versioning](https://semver.org) and the [Keep a Changelog](https://keepachangelog.com) format.

---

## [Unreleased]

### Added
- **AI-driven feature flags** — `FeatureFlag`, `FeatureFlagRegistry` (actor): define named flags with per-`UserType` eligibility and minimum confidence thresholds; auto-evaluated after every prediction pipeline run
- **AI-driven A/B testing** — `Experiment`, `ExperimentEngine` (actor), `ExperimentAssignment`: stable variant assignment per user type backed by a write-once cohort ID (`CohortIdentity`); first call per experiment automatically logs an `experiment_exposed` analytics event
- **`FeatureFlagKey`** — predefined string constants (`batchProcessing`, `exportReport`, `advancedFilters`, `reEngagement`)
- **`View.aiAnalytics(flagRegistry:experimentEngine:)`** — new overload of the scene modifier that wires feature flags and A/B testing into the prediction pipeline
- **`AIAnalytics.isFeatureEnabled(_:) async -> Bool`** — static convenience method for querying flags
- **`AIAnalytics.experimentVariant(for:) async -> ExperimentAssignment?`** — static convenience method for querying experiment variants
- **`AIAnalyticsContainer.makeFeatureFlagRegistry()`** and **`makeExperimentEngine()`** — factory methods on the DI container
- **Debounced real-time UI adaptation** — `trackEvent()` / `trackEvents()` / `trackSampleEvents()` now schedule a debounced `loadInsights()` (default 2 s) instead of running the pipeline synchronously after every event; configurable via `adaptationDebounceInterval` in `HomeViewModel.init`
- **`HomeViewModel.configurationStream: AsyncStream<UIConfiguration>`** — yields a new `UIConfiguration` after every successful prediction; finishes on `clearAllEvents()`
- **Demo app: Personalization tab** — new `PersonalizationTab` showing live feature flag ON/OFF states, experiment variant assignments, and real-time adaptation behaviour; registered with 4 demo flags and 3 demo experiments at launch

### Fixed
- **Shared `AnalyticsManager`** — `AIAnalytics.logEvent()` and `HomeViewModel` previously wrote to separate event stores; both now share `AIAnalyticsContainer.sharedAnalyticsManager`, so static fire-and-forget events are always visible to the AI pipeline

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
