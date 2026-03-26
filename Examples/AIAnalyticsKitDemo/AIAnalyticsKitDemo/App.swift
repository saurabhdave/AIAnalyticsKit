import SwiftUI
import SwiftData
import AIAnalyticsKit

@main
struct AIAnalyticsKitDemoApp: App {

    @State private var homeViewModel = AIAnalyticsContainer.makeHomeViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ContentView(hasCompletedOnboarding: $hasCompletedOnboarding)
                } else {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                }
            }
            .environment(homeViewModel)
            .modelContainer(AIAnalyticsContainer.modelContainer)
            .animation(.easeInOut(duration: 0.35), value: hasCompletedOnboarding)
        }
    }
}
