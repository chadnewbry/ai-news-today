import SwiftUI
import SwiftData

@main
struct AINewsTodayApp: App {
    let container: ModelContainer
    private var storeManager = StoreManager.shared

    init() {
        container = PersistenceService.shared.container
        storeManager.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task { await storeManager.checkEntitlement() }
        }
        .modelContainer(container)
    }
}
