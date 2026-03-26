import SwiftUI
import AIAnalyticsKit

// MARK: - Settings View

struct SettingsView: View {

    @Environment(HomeViewModel.self) private var viewModel
    @Binding var hasCompletedOnboarding: Bool
    @State private var showClearConfirmation = false
    @State private var showResetOnboardingConfirmation = false

    var body: some View {
        List {
            sdkSection
            privacySection
            dataSection
            aboutSection
        }
        .navigationTitle("Settings")
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .confirmationDialog(
            "Clear All Events?",
            isPresented: $showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear All Events", role: .destructive) {
                Task { await viewModel.clearAllEvents() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all tracked events and reset the AI prediction.")
        }
        .confirmationDialog(
            "Replay Onboarding?",
            isPresented: $showResetOnboardingConfirmation,
            titleVisibility: .visible
        ) {
            Button("Show Onboarding Again") {
                hasCompletedOnboarding = false
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - SDK Section

    private var sdkSection: some View {
        Section {
            SettingsInfoRow(
                icon: "brain.fill",
                iconColor: .purple,
                title: "AI Engine",
                value: "Foundation Models"
            )
            SettingsInfoRow(
                icon: "cpu.fill",
                iconColor: .indigo,
                title: "Inference",
                value: "On-Device · Neural Engine"
            )
            SettingsInfoRow(
                icon: "globe",
                iconColor: .gray,
                title: "Network Required",
                value: "Never"
            )
        } header: {
            Text("AIAnalyticsKit")
        } footer: {
            Text("Classification runs entirely on-device using Apple's Foundation Models framework. No data ever leaves the device.")
        }
    }

    // MARK: - Privacy Section

    private var privacySection: some View {
        Section("Privacy") {
            SettingsInfoRow(
                icon: "lock.shield.fill",
                iconColor: .green,
                title: "Data Egress",
                value: "Zero"
            )
            SettingsInfoRow(
                icon: "internaldrive.fill",
                iconColor: .blue,
                title: "Storage",
                value: "SwiftData · On-Device"
            )
            SettingsInfoRow(
                icon: "eye.slash.fill",
                iconColor: .orange,
                title: "Event Data Shared",
                value: "Never"
            )
        }
    }

    // MARK: - Data Section

    private var dataSection: some View {
        Section {
            HStack {
                Label {
                    Text("Events Tracked")
                } icon: {
                    Image(systemName: "number.circle.fill")
                        .foregroundStyle(.blue)
                }
                Spacer()
                Text("\(viewModel.eventCount)")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            if let prediction = viewModel.viewState.prediction {
                HStack {
                    Label {
                        Text("Current Classification")
                    } icon: {
                        Image(systemName: prediction.userType.icon)
                            .foregroundStyle(viewModel.viewState.configuration?.accentColor ?? .secondary)
                    }
                    Spacer()
                    Text(prediction.userType.rawValue)
                        .foregroundStyle(.secondary)
                }
            }

            Button(role: .destructive) {
                showClearConfirmation = true
            } label: {
                Label("Clear All Events", systemImage: "trash.fill")
            }
            .disabled(viewModel.eventCount == 0)

        } header: {
            Text("Data")
        } footer: {
            Text("Clearing events will reset the classification to idle. This action cannot be undone.")
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        Section("About") {
            SettingsInfoRow(
                icon: "shippingbox.fill",
                iconColor: .brown,
                title: "Package",
                value: "AIAnalyticsKit"
            )
            SettingsInfoRow(
                icon: "swift",
                iconColor: .orange,
                title: "Swift Version",
                value: "6.0"
            )
            SettingsInfoRow(
                icon: "iphone",
                iconColor: .secondary,
                title: "Min Deployment",
                value: "iOS 26.0"
            )

            Button {
                showResetOnboardingConfirmation = true
            } label: {
                Label("Replay Onboarding", systemImage: "arrow.counterclockwise")
                    .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - Supporting Views

private struct SettingsInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
            }
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView(hasCompletedOnboarding: .constant(true))
    }
    .environment(AIAnalyticsContainer.makeHomeViewModel())
    .modelContainer(AIAnalyticsContainer.modelContainer)
}
