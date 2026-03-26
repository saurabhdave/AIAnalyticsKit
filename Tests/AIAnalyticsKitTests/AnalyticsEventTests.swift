import Testing
import Foundation
@testable import AIAnalyticsKit

@Suite("AnalyticsEvent")
struct AnalyticsEventTests {

    @Test("Default category is interaction")
    func defaultCategory() {
        let event = AnalyticsEvent(name: "tap")
        #expect(event.category == .interaction)
    }

    @Test("Default properties is empty")
    func defaultProperties() {
        let event = AnalyticsEvent(name: "tap")
        #expect(event.properties.isEmpty)
    }

    @Test("Custom properties are stored")
    func customProperties() {
        let event = AnalyticsEvent(
            name: "navigate",
            category: .navigation,
            properties: ["screen": "Home"]
        )
        #expect(event.properties["screen"] == "Home")
        #expect(event.category == .navigation)
    }

    @Test("Explicit ID is preserved")
    func explicitID() {
        let id = UUID()
        let event = AnalyticsEvent(id: id, name: "test")
        #expect(event.id == id)
    }

    @Test("Auto-generated IDs are unique")
    func uniqueIDs() {
        let e1 = AnalyticsEvent(name: "e1")
        let e2 = AnalyticsEvent(name: "e2")
        #expect(e1.id != e2.id)
    }

    @Test("All event categories are reachable")
    func allCategoriesCovered() {
        let categories: [AnalyticsEvent.EventCategory] = [.navigation, .interaction, .analysis, .error]
        #expect(Set(categories.map(\.rawValue)).count == 4)
    }
}
