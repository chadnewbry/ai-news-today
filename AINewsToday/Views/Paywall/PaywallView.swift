import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    var storeManager = StoreManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    packagesSection
                    restoreButton
                    errorSection
                }
                .padding()
            }
            .navigationTitle("Upgrade to Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .task { await storeManager.loadOfferings() }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.yellow)

            Text("Unlimited AI News")
                .font(.title.bold())

            Text("You've used all your free article reads.\nUpgrade for unlimited access to AI-curated news.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            featureRow(icon: "newspaper.fill", text: "Unlimited article reads")
            featureRow(icon: "bolt.fill", text: "Priority access to breaking news")
            featureRow(icon: "bookmark.fill", text: "Unlimited bookmarks")
            featureRow(icon: "bell.fill", text: "Custom notification topics")
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private var packagesSection: some View {
        if storeManager.isLoading {
            ProgressView()
                .padding()
        } else if let offering = storeManager.currentOffering {
            VStack(spacing: 12) {
                ForEach(offering.availablePackages) { package in
                    Button {
                        Task {
                            let success = await storeManager.purchase(package)
                            if success { dismiss() }
                        }
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(package.storeProduct.localizedTitle)
                                    .fontWeight(.semibold)
                                Text(package.storeProduct.localizedDescription)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(package.localizedPriceString)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        } else {
            Text("Unable to load subscription options.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var restoreButton: some View {
        VStack(spacing: 8) {
            Button("Restore Purchases") {
                Task {
                    await storeManager.restorePurchases()
                    if storeManager.isProUser { dismiss() }
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                Link("Terms of Service", destination: URL(string: "https://ainewstoday.app/terms")!)
                Text("·")
                Link("Privacy Policy", destination: URL(string: "https://ainewstoday.app/privacy")!)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)

            Text("Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period. Manage subscriptions in Settings.")
                .font(.caption2)
                .foregroundStyle(.quaternary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var errorSection: some View {
        if let error = storeManager.errorMessage {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    PaywallView()
}
