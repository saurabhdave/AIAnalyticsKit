import Testing
import Foundation
@testable import AIAnalyticsKit

@Suite("UserPrediction")
struct UserPredictionTests {

    @Test("Confidence is clamped to 0…1 from above")
    func confidenceClampedAbove() {
        let p = UserPrediction(userType: .power, confidence: 1.5)
        #expect(p.confidence == 1.0)
    }

    @Test("Confidence is clamped to 0…1 from below")
    func confidenceClampedBelow() {
        let p = UserPrediction(userType: .casual, confidence: -0.2)
        #expect(p.confidence == 0.0)
    }

    @Test("Confidence within range is preserved")
    func confidenceInRange() {
        let p = UserPrediction(userType: .explorer, confidence: 0.75)
        #expect(p.confidence == 0.75)
    }

    @Test("User type is stored as-is", arguments: UserType.allCases)
    func userTypeStoredAsIs(userType: UserType) {
        let p = UserPrediction(userType: userType, confidence: 0.5)
        #expect(p.userType == userType)
    }

    @Test("generatedAt defaults to now (within 1 second)")
    func generatedAtDefaults() {
        let before = Date.now
        let p = UserPrediction(userType: .casual, confidence: 0.5)
        let after = Date.now
        #expect(p.generatedAt >= before)
        #expect(p.generatedAt <= after)
    }
}
