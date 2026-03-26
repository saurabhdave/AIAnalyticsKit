import SwiftUI

// MARK: - Protocol

/// Contract for generating personalized UI configurations from predictions.
public protocol PersonalizationEngineProtocol: Sendable {
    func configure(for prediction: UserPrediction) -> UIConfiguration
}

// MARK: - Default Implementation

/// Maps AI predictions to concrete UI parameters.
/// Each user type receives a tailored greeting, accent color, and recommended actions.
public struct PersonalizationEngine: PersonalizationEngineProtocol {

    public init() {}

    public func configure(for prediction: UserPrediction) -> UIConfiguration {
        switch prediction.userType {
        case .power:
            return UIConfiguration(
                greeting: String(localized: "Welcome back, power user"),
                accentColor: .purple,
                showAdvancedFeatures: true,
                recommendedActions: [
                    .init(
                        title: String(localized: "Batch Analysis"),
                        subtitle: String(localized: "Analyze multiple log files at once"),
                        icon: "square.stack.3d.up.fill"
                    ),
                    .init(
                        title: String(localized: "Export Report"),
                        subtitle: String(localized: "Generate a detailed analysis report"),
                        icon: "doc.richtext"
                    ),
                ]
            )
        case .casual:
            return UIConfiguration(
                greeting: String(localized: "Welcome back"),
                accentColor: .blue,
                showAdvancedFeatures: false,
                recommendedActions: [
                    .init(
                        title: String(localized: "Quick Scan"),
                        subtitle: String(localized: "Analyze your most recent logs"),
                        icon: "bolt.fill"
                    ),
                    .init(
                        title: String(localized: "Getting Started"),
                        subtitle: String(localized: "Learn about log analysis basics"),
                        icon: "book.fill"
                    ),
                ]
            )
        case .explorer:
            return UIConfiguration(
                greeting: String(localized: "Discover something new"),
                accentColor: .teal,
                showAdvancedFeatures: true,
                recommendedActions: [
                    .init(
                        title: String(localized: "Try Adapter Mode"),
                        subtitle: String(localized: "Enable the enriched analysis path"),
                        icon: "sparkles"
                    ),
                    .init(
                        title: String(localized: "Custom Filters"),
                        subtitle: String(localized: "Filter logs by severity or module"),
                        icon: "line.3.horizontal.decrease.circle.fill"
                    ),
                ]
            )
        case .atRisk:
            return UIConfiguration(
                greeting: String(localized: "We missed you!"),
                accentColor: .orange,
                showAdvancedFeatures: false,
                recommendedActions: [
                    .init(
                        title: String(localized: "What's New"),
                        subtitle: String(localized: "See the latest improvements"),
                        icon: "star.fill"
                    ),
                    .init(
                        title: String(localized: "Quick Help"),
                        subtitle: String(localized: "Get started in under a minute"),
                        icon: "questionmark.circle.fill"
                    ),
                ]
            )
        }
    }
}
