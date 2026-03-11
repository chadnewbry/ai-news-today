import SwiftUI

struct AlertsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.red)
                Text("Breaking Alerts")
                    .font(.title2.bold())
                Text("Real-time AI industry breaking news")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Alerts")
        }
        .accessibilityIdentifier("alertsTab")
    }
}

#Preview {
    AlertsView()
}
