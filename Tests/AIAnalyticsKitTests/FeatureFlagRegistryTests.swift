import Testing
@testable import AIAnalyticsKit

@Suite("FeatureFlagRegistry")
struct FeatureFlagRegistryTests {

    @Test("Returns false before any prediction is set")
    func falseBeforePrediction() async {
        let registry = FeatureFlagRegistry()
        await registry.register(FeatureFlag(key: "k", enabledForUserTypes: [.power]))
        #expect(await !registry.isEnabled("k"))
    }

    @Test("Returns false for unregistered key")
    func falseForUnregisteredKey() async {
        let registry = FeatureFlagRegistry()
        await registry.updatePrediction(UserPrediction(userType: .power, confidence: 1.0))
        #expect(await !registry.isEnabled("not_registered"))
    }

    @Test("Returns true after prediction satisfies flag conditions")
    func trueAfterMatchingPrediction() async {
        let registry = FeatureFlagRegistry()
        await registry.register(FeatureFlag(key: "batch", enabledForUserTypes: [.power], minimumConfidence: 0.7))
        await registry.updatePrediction(UserPrediction(userType: .power, confidence: 0.9))
        #expect(await registry.isEnabled("batch"))
    }

    @Test("Returns false after prediction changes to non-matching type")
    func falseAfterPredictionChange() async {
        let registry = FeatureFlagRegistry()
        await registry.register(FeatureFlag(key: "batch", enabledForUserTypes: [.power]))
        await registry.updatePrediction(UserPrediction(userType: .power, confidence: 1.0))
        await registry.updatePrediction(UserPrediction(userType: .casual, confidence: 1.0))
        #expect(await !registry.isEnabled("batch"))
    }

    @Test("Registering multiple flags at once")
    func registerMultiple() async {
        let registry = FeatureFlagRegistry()
        let flags = [
            FeatureFlag(key: "f1", enabledForUserTypes: [.power]),
            FeatureFlag(key: "f2", enabledForUserTypes: [.explorer]),
        ]
        await registry.register(flags)
        await registry.updatePrediction(UserPrediction(userType: .power, confidence: 1.0))
        #expect(await registry.isEnabled("f1"))
        #expect(await !registry.isEnabled("f2"))
    }

    @Test("Re-registering a flag replaces the previous one")
    func reregistrationReplaces() async {
        let registry = FeatureFlagRegistry()
        await registry.register(FeatureFlag(key: "k", enabledForUserTypes: [.power]))
        await registry.register(FeatureFlag(key: "k", enabledForUserTypes: [.casual]))
        await registry.updatePrediction(UserPrediction(userType: .power, confidence: 1.0))
        // Flag now targets .casual, so .power should be disabled
        #expect(await !registry.isEnabled("k"))
    }
}
