import SwiftUI
import SwiftData

@main
struct AINewsTodayApp: App {
    let container: ModelContainer

    init() {
        container = PersistenceService.shared.container
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
