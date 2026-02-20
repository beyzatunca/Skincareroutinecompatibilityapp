import SwiftUI

@main
struct MyAppApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
            } else {
                NavigationStack {
                    OnboardingView()
                }
            }
        }
    }
}
