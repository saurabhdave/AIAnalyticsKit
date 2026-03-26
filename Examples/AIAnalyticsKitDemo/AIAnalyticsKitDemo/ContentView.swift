import SwiftUI
import AIAnalyticsKit

// MARK: - Root Content View

struct ContentView: View {

    @Binding var hasCompletedOnboarding: Bool
    @State private var showSettings = false

    var body: some View {
        TabView {
            Tab("Insights", systemImage: "brain.fill") {
                NavigationStack {
                    HomeView()
                        .navigationTitle("AI Insights")
                        #if !os(macOS)
                        .navigationBarTitleDisplayMode(.large)
                        #endif
                        .toolbar { settingsToolbarItem }
                }
            }

            Tab("Events", systemImage: "list.bullet.circle.fill") {
                NavigationStack {
                    EventsTab()
                        .navigationTitle("Events")
                        #if !os(macOS)
                        .navigationBarTitleDisplayMode(.large)
                        #endif
                        .toolbar { settingsToolbarItem }
                }
            }

            Tab("Features", systemImage: "waveform.path") {
                NavigationStack {
                    FeaturesTab()
                        .navigationTitle("Feature Vector")
                        #if !os(macOS)
                        .navigationBarTitleDisplayMode(.large)
                        #endif
                        .toolbar { settingsToolbarItem }
                }
            }

            Tab("AI Engine", systemImage: "cpu.fill") {
                NavigationStack {
                    AIEngineTab()
                        .navigationTitle("AI Engine")
                        #if !os(macOS)
                        .navigationBarTitleDisplayMode(.large)
                        #endif
                        .toolbar { settingsToolbarItem }
                }
            }

            Tab("User Types", systemImage: "person.3.fill") {
                NavigationStack {
                    UserTypesTab()
                        .navigationTitle("User Types")
                        #if !os(macOS)
                        .navigationBarTitleDisplayMode(.large)
                        #endif
                        .toolbar { settingsToolbarItem }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") { showSettings = false }
                        }
                    }
            }
        }
    }

    @ToolbarContentBuilder
    private var settingsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView(hasCompletedOnboarding: .constant(true))
        .environment(AIAnalyticsContainer.makeHomeViewModel())
        .modelContainer(AIAnalyticsContainer.modelContainer)
}
