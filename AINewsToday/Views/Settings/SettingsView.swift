import SwiftUI

struct SettingsView: View {
    @State private var notificationManager = NotificationManager.shared

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
                notificationsSection

                if notificationManager.authorizationStatus == .denied {
                    notificationDeniedSection
                }

                supportSection
                legalSection
                aboutSection
            }
            .navigationTitle("Settings")
            .onAppear {
                Task { await notificationManager.refreshAuthorizationStatus() }
            }
        }
    }

    // MARK: - Notifications

    @ViewBuilder
    private var notificationsSection: some View {
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
    }

    @ViewBuilder
    private var notificationDeniedSection: some View {
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

    // MARK: - Support

    @ViewBuilder
    private var supportSection: some View {
        Section("Support") {
            Button {
                emailSupport()
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }
        }
    }

    // MARK: - Legal

    @ViewBuilder
    private var legalSection: some View {
        Section("Legal") {
            Link(destination: URL(string: "https://chadnewbry.github.io/ai-news-today/privacy")!) {
                Label("Privacy Policy", systemImage: "hand.raised")
            }
            Link(destination: URL(string: "https://chadnewbry.github.io/ai-news-today/terms")!) {
                Label("Terms of Use", systemImage: "doc.text")
            }
        }
    }

    // MARK: - About

    @ViewBuilder
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(appVersion)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Helpers

    private func emailSupport() {
        let email = "chad.newbry@gmail.com"
        let subject = "AI News Today Support"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
