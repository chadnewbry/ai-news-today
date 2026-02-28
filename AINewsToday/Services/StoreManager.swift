import Foundation
import RevenueCat

@MainActor
@Observable
final class StoreManager {
    static let shared = StoreManager()

    private(set) var isProUser = false
    private(set) var offerings: Offerings?
    private(set) var currentOffering: Offering?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    static let apiKey = "appl_REPLACE_WITH_REVENUECAT_API_KEY"
    static let entitlementID = "pro"

    private init() {}

    func configure() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Self.apiKey)
    }

    func checkEntitlement() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            isProUser = customerInfo.entitlements[Self.entitlementID]?.isActive == true
        } catch {
            print("StoreManager: Failed to fetch customer info: \(error)")
        }
    }

    func loadOfferings() async {
        isLoading = true
        errorMessage = nil
        do {
            offerings = try await Purchases.shared.offerings()
            currentOffering = offerings?.current
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func purchase(_ package: Package) async -> Bool {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Purchases.shared.purchase(package: package)
            isProUser = result.customerInfo.entitlements[Self.entitlementID]?.isActive == true
            isLoading = false
            return isProUser
        } catch let error as ErrorCode {
            if error == .purchaseCancelledError {
                // User cancelled
            } else {
                errorMessage = error.localizedDescription
            }
            isLoading = false
            return false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            isProUser = customerInfo.entitlements[Self.entitlementID]?.isActive == true
            if !isProUser {
                errorMessage = "No active purchases found."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
