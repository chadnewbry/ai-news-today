import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Coming Soon",
                systemImage: "gearshape",
                description: Text("App settings will appear here.")
            )
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
