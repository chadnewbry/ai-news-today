import Foundation
import UserNotifications

@MainActor
@Observable
final class NotificationManager {
    static let shared = NotificationManager()

    private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined
    var isAuthorized: Bool { authorizationStatus == .authorized }

    // MARK: - User Preferences

    private let dailyDigestEnabledKey = "dailyDigestEnabled"
    private let dailyDigestHourKey = "dailyDigestHour"
    private let dailyDigestMinuteKey = "dailyDigestMinute"

    var dailyDigestEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: dailyDigestEnabledKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: dailyDigestEnabledKey)
            if newValue {
                scheduleDailyDigest()
            } else {
                cancelDailyDigest()
            }
        }
    }

    var dailyDigestHour: Int {
        get {
            let val = UserDefaults.standard.integer(forKey: dailyDigestHourKey)
            return val == 0 && !UserDefaults.standard.bool(forKey: "dailyDigestHourSet") ? 8 : val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: dailyDigestHourKey)
            UserDefaults.standard.set(true, forKey: "dailyDigestHourSet")
            if dailyDigestEnabled { scheduleDailyDigest() }
        }
    }

    var dailyDigestMinute: Int {
        get { UserDefaults.standard.integer(forKey: dailyDigestMinuteKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: dailyDigestMinuteKey)
            if dailyDigestEnabled { scheduleDailyDigest() }
        }
    }

    private static let dailyDigestIdentifier = "daily-news-digest"

    private init() {
        Task { await refreshAuthorizationStatus() }
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            await refreshAuthorizationStatus()
            return granted
        } catch {
            return false
        }
    }

    func refreshAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    // MARK: - Daily Digest Scheduling

    func scheduleDailyDigest() {
        cancelDailyDigest()

        var dateComponents = DateComponents()
        dateComponents.hour = dailyDigestHour
        dateComponents.minute = dailyDigestMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Your AI News Digest"
        content.body = "Today's top AI stories are ready for you."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: Self.dailyDigestIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelDailyDigest() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [Self.dailyDigestIdentifier])
    }
}
