import Foundation
import SwiftData

@Model
final class UserPreferences {
    @Attribute(.unique) var id: String
    var selectedTopics: [String]
    var refreshIntervalMinutes: Int
    var notificationsEnabled: Bool

    init(
        id: String = "default",
        selectedTopics: [String] = ["AI", "Machine Learning", "Tech"],
        refreshIntervalMinutes: Int = 30,
        notificationsEnabled: Bool = false
    ) {
        self.id = id
        self.selectedTopics = selectedTopics
        self.refreshIntervalMinutes = refreshIntervalMinutes
        self.notificationsEnabled = notificationsEnabled
    }
}
