import SwiftUI

struct SettingsView: View {
    @State private var notificationManager = NotificationManager.shared
    @State private var showPaywall = false
    @Environment(\.openURL) private var openURL
    private var storeManager = StoreManager.shared
    private var usageManager = UsageManager.shared

    private var digestTime: Date {
        var components = DateComponents()
        components.hour = notificationManager.dailyDigestHour
        components.minute = notificationManager.dailyDigestMinute
        return Calendar.current.date(from: components) ?? .now
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            Form {
                subscriptionSection

                Section {
                    notificationToggle
                    if notificationManager.dailyDigestEnabled {
                        timePicker
                    }
                } header: {
                    Text("Daily Digest")
                } footer: {
                    Text("Get a daily notification when your AI news digest is ready.")
                }

                if notificationManager.authorizationStatus == .denied {
                    Section {
                        Button("Open Notification Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    } footer: {
                        Text("Notifications are disabled. Enable them in Settings to receive daily digest alerts.")
                    }
                }

                Section("Support") {
                    Link(destination: URL(string: "https://ainewstoday.app/support")!) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }

                    Link(destination: URL(string: "https://ainewstoday.app/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }

                    Link(destination: URL(string: "https://ainewstoday.app/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                Task { await notificationManager.refreshAuthorizationStatus() }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    @ViewBuilder
    private var subscriptionSection: some View {
        Section {
            if storeManager.isProUser {
                HStack {
                    Label("AI News Pro", systemImage: "star.fill")
                        .foregroundStyle(.yellow)
                    Spacer()
                    Text("Active")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Free Plan")
                            .font(.headline)
                        Text("\(usageManager.freeUsesRemaining) of \(UsageManager.defaultFreeUses) free reads remaining today")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Upgrade") { showPaywall = true }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                }
            }

            Button("Restore Purchases") {
                Task { await storeManager.restorePurchases() }
            }

            if let error = storeManager.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        } header: {
            Text("Subscription")
        }
    }

    @ViewBuilder
    private var notificationToggle: some View {
        Toggle("Daily News Alert", isOn: Binding(
            get: { notificationManager.dailyDigestEnabled },
            set: { newValue in
                if newValue && !notificationManager.isAuthorized {
                    Task {
                        let granted = await notificationManager.requestAuthorization()
                        if granted {
                            notificationManager.dailyDigestEnabled = true
                        }
                    }
                } else {
                    notificationManager.dailyDigestEnabled = newValue
                }
            }
        ))
    }

    @ViewBuilder
    private var timePicker: some View {
        DatePicker(
            "Delivery Time",
            selection: Binding(
                get: { digestTime },
                set: { newDate in
                    let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                    notificationManager.dailyDigestHour = components.hour ?? 8
                    notificationManager.dailyDigestMinute = components.minute ?? 0
                }
            ),
            displayedComponents: .hourAndMinute
        )
    }
}

#Preview {
    SettingsView()
}
