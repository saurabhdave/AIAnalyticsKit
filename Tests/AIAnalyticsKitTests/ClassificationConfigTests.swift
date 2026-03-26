import Testing
@testable import AIAnalyticsKit

@Suite("ClassificationConfig")
struct ClassificationConfigTests {

    @Test("Confidence values are in 0…1 range")
    func confidenceValuesInRange() {
        #expect(ClassificationConfig.foundationModelConfidence >= 0.0)
        #expect(ClassificationConfig.foundationModelConfidence <= 1.0)
        #expect(ClassificationConfig.heuristicFallbackConfidence >= 0.0)
        #expect(ClassificationConfig.heuristicFallbackConfidence <= 1.0)
        #expect(ClassificationConfig.coreMLModelConfidence >= 0.0)
        #expect(ClassificationConfig.coreMLModelConfidence <= 1.0)
    }

    @Test("Foundation model confidence is higher than heuristic fallback")
    func foundationHigherThanHeuristic() {
        #expect(ClassificationConfig.foundationModelConfidence > ClassificationConfig.heuristicFallbackConfidence)
    }

    @Test("Threshold constants are positive")
    func thresholdsArePositive() {
        #expect(ClassificationConfig.atRiskErrorRate > 0)
        #expect(ClassificationConfig.powerUserMinEvents > 0)
        #expect(ClassificationConfig.powerUserMinAnalyses > 0)
        #expect(ClassificationConfig.explorerMinScreens > 0)
    }
}
