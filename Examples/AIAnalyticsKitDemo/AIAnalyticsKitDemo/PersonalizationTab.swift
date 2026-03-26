import SwiftUI
import AIAnalyticsKit

// MARK: - Personalization Tab

struct PersonalizationTab: View {

    let flagRegistry: FeatureFlagRegistry
    let experimentEngine: ExperimentEngine

    @Environment(HomeViewModel.self) private var viewModel

    @State private var flagStates: [String: Bool] = [:]
    @State private var experimentAssignments: [String: ExperimentAssignment] = [:]

    private var currentType: UserType? {
        viewModel.viewState.prediction?.userType
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                featureFlagsCard
                experimentsCard
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: currentType) {
            await refreshFlagStates()
            await refreshExperimentAssignments()
        }
    }

    // MARK: - Header

    private var headerCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(icon: "slider.horizontal.3", title: "Personalization")
                Text("AI-driven feature flags and A/B test assignments based on the current user classification.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let type = currentType {
                    HStack(spacing: 6) {
                        Image(systemName: "scope")
                            .imageScale(.small)
                        Text("Current type: ")
                            .font(.caption)
                        Text(type.rawValue)
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                }
            }
        }
    }

    // MARK: - Feature Flags

    private var featureFlagsCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(icon: "flag.fill", title: "Feature Flags")

                if flagStates.isEmpty {
                    Text("Run the AI pipeline on the Insights tab to evaluate flags.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(flagStates.sorted(by: { $0.key < $1.key }), id: \.key) { key, enabled in
                        FlagRow(key: key, isEnabled: enabled)
                    }
                }
            }
        }
    }

    // MARK: - Experiments

    private var experimentsCard: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(icon: "flask.fill", title: "A/B Experiments")

                if experimentAssignments.isEmpty {
                    Text("Run the AI pipeline on the Insights tab to resolve experiment assignments.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(experimentAssignments.sorted(by: { $0.key < $1.key }), id: \.key) { key, assignment in
                        ExperimentRow(assignment: assignment)
                    }
                }
            }
        }
    }

    // MARK: - Data Loading

    private func refreshFlagStates() async {
        let keys = [
            FeatureFlagKey.batchProcessing,
            FeatureFlagKey.exportReport,
            FeatureFlagKey.advancedFilters,
            FeatureFlagKey.reEngagement,
        ]
        var states: [String: Bool] = [:]
        for key in keys {
            states[key] = await flagRegistry.isEnabled(key)
        }
        flagStates = states
    }

    private func refreshExperimentAssignments() async {
        let keys = ["dashboard_layout", "onboarding_flow", "cta_copy"]
        var assignments: [String: ExperimentAssignment] = [:]
        for key in keys {
            if let assignment = await experimentEngine.assignment(for: key) {
                assignments[key] = assignment
            }
        }
        experimentAssignments = assignments
    }
}

// MARK: - Supporting Views

private struct FlagRow: View {
    let key: String
    let isEnabled: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isEnabled ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(isEnabled ? .green : .secondary)
                .frame(width: 20)
            Text(key)
                .font(.subheadline)
            Spacer()
            Text(isEnabled ? "Enabled" : "Disabled")
                .font(.caption.weight(.semibold))
                .foregroundStyle(isEnabled ? .green : .secondary)
        }
    }
}

private struct ExperimentRow: View {
    let assignment: ExperimentAssignment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(assignment.experimentKey)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(assignment.variant)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .foregroundStyle(.purple)
                    .glassEffect(.regular.tint(.purple))
            }
            HStack(spacing: 16) {
                Label("\(assignment.userType.rawValue)", systemImage: "person.fill")
                Label("\(Int(assignment.confidence * 100))%", systemImage: "chart.bar.fill")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Preview

#Preview {
    let registry = AIAnalyticsContainer.makeFeatureFlagRegistry()
    let engine = AIAnalyticsContainer.makeExperimentEngine()
    NavigationStack {
        PersonalizationTab(flagRegistry: registry, experimentEngine: engine)
            .navigationTitle("Personalization")
    }
    .environment(AIAnalyticsContainer.makeHomeViewModel(flagRegistry: registry, experimentEngine: engine))
    .modelContainer(AIAnalyticsContainer.modelContainer)
}
