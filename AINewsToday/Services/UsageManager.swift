import Foundation

@MainActor
@Observable
final class UsageManager {
    static let shared = UsageManager()

    static let defaultFreeUses = 5
    private static let usageCountKey = "ainewstoday_usage_count"
    private static let usageDateKey = "ainewstoday_usage_date"

    var usageCount: Int {
        didSet { UserDefaults.standard.set(usageCount, forKey: Self.usageCountKey) }
    }

    var freeUsesRemaining: Int {
        max(0, Self.defaultFreeUses - usageCount)
    }

    var hasFreeUsesLeft: Bool {
        freeUsesRemaining > 0
    }

    private init() {
        self.usageCount = UserDefaults.standard.integer(forKey: Self.usageCountKey)
        resetIfNewDay()
    }

    /// Record one "use" (reading an article). Returns true if the use was allowed.
    func recordUse(isPro: Bool) -> Bool {
        if isPro { return true }
        resetIfNewDay()
        guard hasFreeUsesLeft else { return false }
        usageCount += 1
        return true
    }

    func reset() {
        usageCount = 0
        saveTodayAsUsageDate()
    }

    private func resetIfNewDay() {
        let lastDateString = UserDefaults.standard.string(forKey: Self.usageDateKey) ?? ""
        let todayString = Self.todayString()
        if lastDateString != todayString {
            usageCount = 0
            saveTodayAsUsageDate()
        }
    }

    private func saveTodayAsUsageDate() {
        UserDefaults.standard.set(Self.todayString(), forKey: Self.usageDateKey)
    }

    private static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
