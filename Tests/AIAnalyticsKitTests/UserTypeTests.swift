import Testing
@testable import AIAnalyticsKit

@Suite("UserType")
struct UserTypeTests {

    @Test("All cases present", arguments: UserType.allCases)
    func allCasesHaveRawValues(userType: UserType) {
        #expect(!userType.rawValue.isEmpty)
        #expect(!userType.icon.isEmpty)
        #expect(!userType.typeDescription.isEmpty)
    }

    @Test("Raw values are stable")
    func rawValues() {
        #expect(UserType.power.rawValue == "Power User")
        #expect(UserType.casual.rawValue == "Casual User")
        #expect(UserType.explorer.rawValue == "Explorer")
        #expect(UserType.atRisk.rawValue == "At-Risk")
    }

    @Test("ID matches raw value")
    func idMatchesRawValue() {
        for type_ in UserType.allCases {
            #expect(type_.id == type_.rawValue)
        }
    }

    @Test("Identifiable conformance yields unique IDs")
    func uniqueIDs() {
        let ids = UserType.allCases.map(\.id)
        #expect(Set(ids).count == UserType.allCases.count)
    }
}
