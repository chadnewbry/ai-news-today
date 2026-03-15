import SwiftUI
import SwiftData

@main
struct AINewsTodayApp: App {
    let container: ModelContainer

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        container = PersistenceService.shared.container
        StoreManager.shared.configure()

        #if DEBUG
        if ScreenshotSampleData.isScreenshotMode {
            let context = container.mainContext
            ScreenshotSampleData.populate(context: context)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(container)
    }
}
