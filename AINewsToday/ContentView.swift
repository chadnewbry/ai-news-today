import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .feed

    enum Tab {
        case feed, bookmarks, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "newspaper.fill")
                }
                .tag(Tab.feed)

            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark.fill")
                }
                .tag(Tab.bookmarks)

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
