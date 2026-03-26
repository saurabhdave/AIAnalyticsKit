<div align="center">

<br/>

<img src="https://img.shields.io/badge/AIAnalyticsKit-1.0-6E40C9?style=for-the-badge&logoColor=white" alt="AIAnalyticsKit"/>

### On-device user behavior analytics and AI personalization
### powered by Apple's Foundation Models framework

*Classify users · Extract features · Personalize UI — entirely on the Neural Engine*

<br/>

[![Swift](https://img.shields.io/badge/Swift-6.0-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-26.0+-000000?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-26.0+-000000?style=flat-square&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![SPM](https://img.shields.io/badge/SPM-compatible-34C759?style=flat-square)](https://swift.org/package-manager/)
[![Foundation Models](https://img.shields.io/badge/Foundation%20Models-✦-6E40C9?style=flat-square)](https://developer.apple.com/documentation/foundationmodels)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

</div>

---

## Overview

AIAnalyticsKit is a Swift 6 library that brings AI-powered user classification and adaptive UI personalization entirely on-device. It tracks user behavior events, extracts a feature vector, feeds it into Apple's Foundation Models framework, and delivers a tailored `UIConfiguration` — all without a network request.

```
Track events  →  Build features  →  Predict user type  →  Adapt your UI
     ↓                ↓                    ↓                    ↓
SwiftData        6-dimension           Foundation           Greeting ·
persistence      feature vector        Models on            Accent color ·
                                       Neural Engine        Recommended
                                                            actions
```

---

## Why AIAnalyticsKit?

Traditional personalization pipelines ship user data to a remote server. AIAnalyticsKit keeps everything on-device:

|                         | Traditional Pipeline | AIAnalyticsKit     |
|-------------------------|:--------------------:|:------------------:|
| Network required        | ✅                   | ❌                 |
| User data leaves device | ✅                   | ❌                 |
| Inference latency       | 500 ms – 2 s         | **< 200 ms**       |
| Works offline           | ❌                   | ✅                 |
| Privacy compliant       | Conditional          | ✅ by design       |
| Personalised UI         | ❌                   | ✅                 |

---

## Requirements

| Requirement | Minimum  |
|-------------|----------|
| iOS         | **26.0** |
| macOS       | **26.0** |
| Xcode       | **26.0** |
| Swift       | **6.0**  |

No external dependencies — only Apple frameworks: `FoundationModels`, `SwiftData`, `SwiftUI`, `OSLog`.

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AIAnalyticsKit", from: "1.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: ["AIAnalyticsKit"])
]
```

Or in Xcode: **File → Add Package Dependencies…** and paste the repository URL.

---

## Quick Start

### 1 · Set up in App.swift — one line

```swift
import SwiftUI
import AIAnalyticsKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .aiAnalytics()  // configures everything: persistence, ViewModel, AI engine
        }
    }
}
```

`.aiAnalytics()` wires the full object graph: SwiftData store, `AnalyticsManager`, Foundation Models engine, and `HomeViewModel`. It injects them into the SwiftUI environment so every view in the hierarchy has access.

### 2 · Log events from anywhere

```swift
// No await, no ViewModel, no Task — call from any file or actor
AIAnalytics.logEvent("button_tapped", parameters: ["id": "subscribe_cta"])
AIAnalytics.logEvent("purchase_completed", parameters: ["product": "premium", "price": 9.99])

// Convenience for screen views
AIAnalytics.logScreenView("DashboardScreen")
AIAnalytics.logScreenView("SettingsScreen", screenClass: "SettingsView")
```

**Category is inferred automatically from the event name** — no enum required:

| Event name pattern | Inferred category |
|--------------------|-------------------|
| starts with `screen_` or ends with `_viewed` | `.navigation` |
| contains `error` or `crash` | `.error` |
| contains `analys`, `report`, or `insight` | `.analysis` |
| everything else | `.interaction` |

### 3 · Show AI-powered insights (optional)

Use the ready-made `HomeView` which runs the full prediction pipeline automatically:

```swift
// HomeView and HomeViewModel are already injected by .aiAnalytics()
// Just use them in any view:
@Environment(HomeViewModel.self) private var viewModel

// Trigger the pipeline manually
await viewModel.loadInsights()

// Read the result
if case .ready(let config, let prediction) = viewModel.viewState {
    print(prediction.userType.rawValue)  // "Power User"
    print(config.greeting)               // "Welcome back, power user"
}
```

---

## Advanced Usage

### Manual event tracking (with immediate UI refresh)

`AIAnalytics.logEvent()` is fire-and-forget — it persists events but does not refresh the insights UI. When you need the UI to update right after tracking:

```swift
@Environment(HomeViewModel.self) private var viewModel

// Track + refresh in one call
Task {
    await viewModel.trackEvent(
        name: "analysis_started",
        category: .analysis,
        properties: ["type": "deep_scan"]
    )
}

// Or: log statically, then refresh separately
AIAnalytics.logEvent("analysis_started", parameters: ["type": "deep_scan"])
Task { await viewModel.loadInsights() }
```

### Batch tracking

```swift
let events: [AnalyticsEvent] = [
    AnalyticsEvent(name: "app_opened",    category: .navigation, properties: ["screen": "home"]),
    AnalyticsEvent(name: "scan_started",  category: .analysis),
    AnalyticsEvent(name: "item_selected", category: .interaction, properties: ["id": "42"]),
]
await viewModel.trackEvents(events)
```

### Manual setup (without `.aiAnalytics()`)

For apps that need explicit control over the setup:

```swift
@main
struct MyApp: App {
    @State private var viewModel = AIAnalytics.makeHomeViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .modelContainer(AIAnalytics.modelContainer)
        }
    }
}
```

---

## Public API

### `AIAnalytics` — Static Facade

The primary entry point. Works like Firebase Analytics — call from anywhere.

```swift
// Log a named event with optional parameters
AIAnalytics.logEvent(_ name: String, parameters: [String: Any] = [:])

// Log a screen view (shorthand for logEvent("screen_viewed", ...))
AIAnalytics.logScreenView(_ screenName: String, screenClass: String? = nil)

// Advanced: access underlying objects directly
AIAnalytics.modelContainer     // @MainActor ModelContainer
AIAnalytics.makeHomeViewModel() // @MainActor HomeViewModel
```

---

### `View.aiAnalytics()` — Scene Modifier

```swift
// Applied to the root view inside WindowGroup
ContentView()
    .aiAnalytics()
```

Injects:
- `.modelContainer(AIAnalytics.modelContainer)` — SwiftData persistence
- `.environment(HomeViewModel)` — AI insights + event tracking

---

### `HomeViewModel`

`@Observable @MainActor` class. Access via `@Environment(HomeViewModel.self)`.

**State:**

```swift
var viewState: HomeViewState        // .idle | .loading | .ready(config, prediction) | .failure(message)
var eventCount: Int                 // total persisted events
var recentEvents: [AnalyticsEvent]  // all events, newest first
var currentFeatures: UserFeatures?  // last extracted feature vector
```

**Actions:**

```swift
func loadInsights() async                                                      // full pipeline
func trackEvent(name:category:properties:) async                               // track + refresh
func trackEvents(_ events: [AnalyticsEvent]) async                             // batch + refresh
func trackSampleEvents() async                                                 // 5 built-in samples
func clearAllEvents() async                                                    // delete all + reset
```

---

### `AnalyticsEvent`

```swift
public struct AnalyticsEvent: Sendable, Identifiable {
    public let id: UUID
    public let name: String
    public let category: EventCategory  // default: .interaction
    public let properties: [String: String]
    public let timestamp: Date

    public enum EventCategory: String, Sendable, CaseIterable {
        case navigation    // screen transitions
        case interaction   // taps, selections, gestures
        case analysis      // compute-heavy operations
        case error         // failures, timeouts, crashes
    }
}
```

---

### `ClassificationConfig`

Single source of truth for all thresholds and confidence values. Reference these in your own UI to stay in sync with the engine.

```swift
public enum ClassificationConfig {
    // Heuristic thresholds
    static let atRiskErrorRate: Double     // 0.30
    static let powerUserMinEvents: Int     // 50
    static let powerUserMinAnalyses: Int   // 10
    static let explorerMinScreens: Int     // 5

    // Prediction confidence
    static let foundationModelConfidence: Double   // 0.85
    static let heuristicFallbackConfidence: Double // 0.60
    static let coreMLModelConfidence: Double       // 0.75
}
```

---

### `UserFeatures`

6-dimension feature vector produced by `FeatureBuilder`.

```swift
public struct UserFeatures: Sendable {
    public let totalEvents: Int
    public let uniqueScreens: Int           // distinct "screen" values in navigation events
    public let averageSessionDuration: TimeInterval
    public let errorRate: Double            // errorEvents / totalEvents  (0.0 – 1.0)
    public let analysisCount: Int
    public let daysSinceFirstEvent: Int

    public static let empty: UserFeatures
}
```

---

### `UserType` · `UserPrediction`

```swift
public enum UserType: String, Sendable, CaseIterable, Identifiable {
    case power    = "Power User"
    case casual   = "Casual User"
    case explorer = "Explorer"
    case atRisk   = "At-Risk"

    public var icon: String             // SF Symbol name
    public var typeDescription: String  // human-readable description
}

public struct UserPrediction: Sendable {
    public let userType: UserType
    public let confidence: Double  // 0.0 – 1.0, auto-clamped
    public let generatedAt: Date
}
```

---

### `UIConfiguration`

Personalization payload produced by `PersonalizationEngine`.

```swift
public struct UIConfiguration: Sendable {
    public let greeting: String
    public let accentColor: Color
    public let showAdvancedFeatures: Bool
    public let recommendedActions: [RecommendedAction]

    public struct RecommendedAction: Sendable, Identifiable {
        public let title: String
        public let subtitle: String
        public let icon: String  // SF Symbol name
    }

    public static let `default`: UIConfiguration
}
```

---

### `HomeViewState`

```swift
public enum HomeViewState: Sendable {
    case idle
    case loading
    case ready(UIConfiguration, UserPrediction)
    case failure(String)  // user-friendly message, real error logged via OSLog

    public var isLoading: Bool
    public var configuration: UIConfiguration?
    public var prediction: UserPrediction?
    public var errorMessage: String?
}
```

---

### Reusable UI Components

```swift
CardContainer { /* any SwiftUI content */ }           // card surface — material, shadow
SectionHeader(icon: "chart.bar.fill", title: "…")     // icon + uppercase label
ErrorBanner(message: "…")                             // orange inline error banner
```

---

## User Classification

### User Types

| Type | Icon | Description |
|---|:---:|---|
| **Power User** | ⚡ | Highly engaged, frequent deep interactions |
| **Casual User** | 🌿 | Occasional, surface-level sessions |
| **Explorer** | 🧭 | Actively discovering new features and screens |
| **At-Risk** | ⚠️ | Declining engagement, high error rate |

### Classification Rules

Evaluated in priority order. Thresholds are defined in `ClassificationConfig`.

```
1. errorRate > ClassificationConfig.atRiskErrorRate (0.30)
       → At-Risk

2. totalEvents > ClassificationConfig.powerUserMinEvents (50)
   AND analysisCount > ClassificationConfig.powerUserMinAnalyses (10)
       → Power User

3. uniqueScreens > ClassificationConfig.explorerMinScreens (5)
       → Explorer

4. (none of the above)
       → Casual User
```

> `uniqueScreens` is derived from the `"screen"` key in `.navigation` event properties.
> Always include it: `AIAnalytics.logEvent("screen_viewed", parameters: ["screen": "dashboard"])`

### Personalization Map

| User Type   | Accent | Advanced | Recommended Actions              |
|-------------|--------|:--------:|----------------------------------|
| Power User  | Purple | ✅       | Batch Analysis · Export Report   |
| Casual User | Blue   | ❌       | Quick Scan · Getting Started     |
| Explorer    | Teal   | ✅       | Try Adapter Mode · Custom Filters|
| At-Risk     | Orange | ❌       | What's New · Quick Help          |

---

## Architecture

### Pipeline

```
AIAnalytics.logEvent() / viewModel.trackEvent()
    │
    ▼
AnalyticsManager (actor)
    │
    ▼
SwiftDataEventStore (@ModelActor)   ← persistent SQLite store, survives restarts
    │
    ▼ (on viewModel.loadInsights())
FeatureBuilder.buildFeatures(from:)
    │   └── UserFeatures (6-dim vector)
    ▼
FoundationPredictionEngine.predict(from:)
    │   └── SystemLanguageModel(.general) or heuristic fallback
    ▼
PersonalizationEngine.configure(for:)
    │   └── UIConfiguration (greeting · color · actions)
    ▼
HomeView / your SwiftUI views
```

### Module Layout

```
Sources/AIAnalyticsKit/
├── AIAnalytics.swift            ← static facade (logEvent, logScreenView)
├── SwiftUI+AIAnalytics.swift    ← .aiAnalytics() View modifier
├── AI/
│   ├── AIEngine.swift
│   ├── ClassificationConfig.swift   ← shared thresholds + confidence values
│   ├── FoundationPredictionEngine.swift
│   ├── CoreMLPredictionEngine.swift
│   ├── UserPrediction.swift
│   └── UserType.swift
├── Analytics/
│   ├── AnalyticsEvent.swift
│   ├── AnalyticsManager.swift
│   └── AnalyticsTracking.swift
├── Storage/
│   ├── EventStore.swift
│   ├── SwiftDataEventStore.swift
│   └── AnalyticsEventModel.swift
├── Features/
│   ├── UserFeatures.swift
│   └── FeatureBuilder.swift
├── Personalization/
│   ├── UIConfiguration.swift
│   └── PersonalizationEngine.swift
├── Presentation/
│   ├── HomeView.swift
│   ├── HomeViewModel.swift
│   ├── HomeViewState.swift
│   ├── CardContainer.swift
│   ├── SectionHeader.swift
│   └── ErrorBanner.swift
└── Container/
    └── AIAnalyticsContainer.swift   ← composition root / DI factory
```

---

## Key Design Patterns

**Firebase-style static API** — `AIAnalytics.logEvent()` works from any file or actor without referencing a ViewModel. Fire-and-forget, no `await` needed.

**Swift 6 strict concurrency** — `AnalyticsManager` and `SwiftDataEventStore` are actors. All cross-actor boundaries are explicit. `.swiftLanguageMode(.v6)` enforced in `Package.swift`.

**`@ModelActor` for SwiftData** — database access happens on a dedicated actor, preventing main-thread blocking.

**Explicit view state** — `HomeViewState` is a value-type enum. No ambiguous `isLoading + data` flag combinations.

**Protocol seams** — `AIEngine`, `EventStore`, `FeatureBuilding`, `PersonalizationEngineProtocol`. Swap any layer with a test double by injecting into `HomeViewModel.init`.

**Graceful degradation** — SwiftData persistent store failure falls back to an in-memory store so the app remains functional. Foundation Models unavailability falls back to deterministic heuristics.

---

## Demo App

`Examples/AIAnalyticsKitDemo/` is a standalone Xcode project. Open `AIAnalyticsKitDemo.xcodeproj` directly — no workspace needed.

```bash
xcodebuild -project Examples/AIAnalyticsKitDemo/AIAnalyticsKitDemo.xcodeproj \
           -scheme AIAnalyticsKitDemo \
           -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
           build
```

| Screen | What it shows |
|---|---|
| **Onboarding** | 3-page swipeable intro with privacy messaging |
| **Insights** | Live `HomeView` — adaptive greeting, accent color, recommended actions |
| **Events** | Category breakdown, quick-log buttons using `AIAnalytics.logEvent()`, behavior simulators |
| **Feature Vector** | Animated progress bars for each `UserFeatures` dimension, classification threshold legend |
| **AI Engine** | Foundation Models info, confidence gauge, feature attribution, privacy guarantees |
| **User Types** | Expandable cards for all 4 types — personalization preview, classification triggers |
| **Settings** | Engine info, live event count, clear data with confirmation |

---

## License

MIT © 2025 · See [LICENSE](LICENSE)
