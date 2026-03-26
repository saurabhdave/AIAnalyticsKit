import Testing
@testable import AIAnalyticsKit

@Suite("FeatureFlag")
struct FeatureFlagTests {

    @Test("Enabled when user type matches and confidence sufficient")
    func enabledForMatchingUserType() {
        let flag = FeatureFlag(key: "f1", enabledForUserTypes: [.power], minimumConfidence: 0.7)
        let prediction = UserPrediction(userType: .power, confidence: 0.9)
        #expect(flag.isEnabled(for: prediction))
    }

    @Test("Disabled when user type does not match")
    func disabledForNonMatchingUserType() {
        let flag = FeatureFlag(key: "f1", enabledForUserTypes: [.power], minimumConfidence: 0.0)
        let prediction = UserPrediction(userType: .casual, confidence: 1.0)
        #expect(!flag.isEnabled(for: prediction))
    }

    @Test("Disabled when confidence is below minimum")
    func disabledWhenConfidenceTooLow() {
        let flag = FeatureFlag(key: "f1", enabledForUserTypes: [.power], minimumConfidence: 0.8)
        let prediction = UserPrediction(userType: .power, confidence: 0.5)
        #expect(!flag.isEnabled(for: prediction))
    }

    @Test("Enabled at exactly the minimum confidence threshold")
    func enabledAtExactThreshold() {
        let flag = FeatureFlag(key: "f1", enabledForUserTypes: [.explorer], minimumConfidence: 0.6)
        let prediction = UserPrediction(userType: .explorer, confidence: 0.6)
        #expect(flag.isEnabled(for: prediction))
    }

    @Test("Multiple user types: enabled for any matching type")
    func enabledForMultipleTypes() {
        let flag = FeatureFlag(key: "f1", enabledForUserTypes: [.power, .explorer], minimumConfidence: 0.0)
        #expect(flag.isEnabled(for: UserPrediction(userType: .power, confidence: 0.5)))
        #expect(flag.isEnabled(for: UserPrediction(userType: .explorer, confidence: 0.5)))
        #expect(!flag.isEnabled(for: UserPrediction(userType: .casual, confidence: 0.5)))
    }

    @Test("Default minimumConfidence is 0")
    func defaultMinimumConfidence() {
        let flag = FeatureFlag(key: "f1", enabledForUserTypes: [.casual])
        #expect(flag.minimumConfidence == 0.0)
        #expect(flag.isEnabled(for: UserPrediction(userType: .casual, confidence: 0.0)))
    }
}
