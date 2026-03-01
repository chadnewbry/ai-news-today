import SwiftUI

struct SettingsView: View {
    @State private var notificationManager = NotificationManager.shared
    @State private var showingTimePicker = false

    private let privacyPolicyURL = URL(string: "https://chadnewbry.github.io/ai-news-today/privacy-policy")!
    private let termsOfServiceURL = URL(string: "https://chadnewbry.github.io/ai-news-today/terms-of-service")!
    private let supportURL = URL(string: "https://chadnewbry.github.io/ai-news-today/support")!

    private var digestTime: Date {
        var components = DateComponents()
        components.hour = notificationManager.dailyDigestHour
        components.minute = notificationManager.dailyDigestMinute
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
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

                Section("Legal") {
                    Link(destination: privacyPolicyURL) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    Link(destination: termsOfServiceURL) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    Link(destination: supportURL) {
                        Label("Support", systemImage: "questionmark.circle")
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                Task { await notificationManager.refreshAuthorizationStatus() }
            }
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
