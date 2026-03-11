import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .briefing

    enum Tab: String {
        case briefing, feed, alerts, discover, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DailyBriefingView()
                .tabItem {
                    Label("Briefing", systemImage: "sun.horizon.fill")
                }
                .tag(Tab.briefing)

            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "newspaper.fill")
                }
                .tag(Tab.feed)

            AlertsView()
                .tabItem {
                    Label("Alerts", systemImage: "bolt.fill")
                }
                .tag(Tab.alerts)

            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(Tab.discover)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .tint(.accentColor)
    }
}

#Preview {
    ContentView()
}
