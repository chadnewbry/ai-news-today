import Foundation

@MainActor
@Observable
final class UsageManager {
    static let shared = UsageManager()

    static let defaultFreeUses = 5
    private static let usageCountKey = "ainewstoday_usage_count"

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
    }

    /// Record one "use" (reading an article). Returns true if the use was allowed.
    func recordUse(isPro: Bool) -> Bool {
        if isPro { return true }
        guard hasFreeUsesLeft else { return false }
        usageCount += 1
        return true
    }

    func reset() {
        usageCount = 0
    }
}
