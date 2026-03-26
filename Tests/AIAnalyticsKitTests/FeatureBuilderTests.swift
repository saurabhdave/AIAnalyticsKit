import Testing
import Foundation
@testable import AIAnalyticsKit

@Suite("FeatureBuilder")
struct FeatureBuilderTests {

    private let builder = FeatureBuilder()

    @Test("Empty events returns empty features")
    func emptyEvents() {
        let features = builder.buildFeatures(from: [])
        #expect(features.totalEvents == 0)
        #expect(features.uniqueScreens == 0)
        #expect(features.errorRate == 0.0)
        #expect(features.analysisCount == 0)
    }

    @Test("Total event count matches input count")
    func totalEventCount() {
        let events = (0..<5).map { AnalyticsEvent(name: "e\($0)") }
        let features = builder.buildFeatures(from: events)
        #expect(features.totalEvents == 5)
    }

    @Test("Unique screens counts distinct screen property values")
    func uniqueScreenCount() {
        let events = [
            AnalyticsEvent(name: "nav", category: .navigation, properties: ["screen": "Home"]),
            AnalyticsEvent(name: "nav", category: .navigation, properties: ["screen": "Home"]),
            AnalyticsEvent(name: "nav", category: .navigation, properties: ["screen": "Settings"]),
            AnalyticsEvent(name: "tap"),
        ]
        let features = builder.buildFeatures(from: events)
        #expect(features.uniqueScreens == 2)
    }

    @Test("Error rate is fraction of error events")
    func errorRate() {
        let events = [
            AnalyticsEvent(name: "e", category: .error),
            AnalyticsEvent(name: "e", category: .error),
            AnalyticsEvent(name: "ok"),
            AnalyticsEvent(name: "ok"),
        ]
        let features = builder.buildFeatures(from: events)
        #expect(features.errorRate == 0.5)
    }

    @Test("Error rate is 0 when no error events")
    func noErrors() {
        let events = [
            AnalyticsEvent(name: "tap"),
            AnalyticsEvent(name: "nav", category: .navigation),
        ]
        let features = builder.buildFeatures(from: events)
        #expect(features.errorRate == 0.0)
    }

    @Test("Analysis count matches number of analysis-category events")
    func analysisCount() {
        let events = [
            AnalyticsEvent(name: "a1", category: .analysis),
            AnalyticsEvent(name: "a2", category: .analysis),
            AnalyticsEvent(name: "tap"),
        ]
        let features = builder.buildFeatures(from: events)
        #expect(features.analysisCount == 2)
    }

    @Test("Navigation events without screen property do not count as screens")
    func navigationWithoutScreenProperty() {
        let events = [
            AnalyticsEvent(name: "nav", category: .navigation),  // no "screen" key
        ]
        let features = builder.buildFeatures(from: events)
        #expect(features.uniqueScreens == 0)
    }
}
