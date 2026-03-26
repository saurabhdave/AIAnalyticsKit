import Testing
@testable import AIAnalyticsKit

@Suite("Experiment")
struct ExperimentTests {

    @Test("Default control variant is 'control'")
    func defaultControlVariant() {
        let exp = Experiment(key: "e", variantsByUserType: [:])
        #expect(exp.controlVariant == "control")
    }

    @Test("Variant resolved for mapped user type")
    func variantForMappedType() {
        let exp = Experiment(
            key: "dashboard_v2",
            variantsByUserType: [.power: "variant_b"],
            controlVariant: "variant_a"
        )
        #expect(exp.variantsByUserType[.power] == "variant_b")
    }

    @Test("Unmapped user type falls back to controlVariant")
    func fallbackForUnmappedType() {
        let exp = Experiment(
            key: "dashboard_v2",
            variantsByUserType: [.power: "variant_b"],
            controlVariant: "variant_a"
        )
        #expect(exp.variantsByUserType[.casual] == nil)
    }

    @Test("Key is stored as-is")
    func keyIsPreserved() {
        let exp = Experiment(key: "my_experiment", variantsByUserType: [:])
        #expect(exp.key == "my_experiment")
    }
}
