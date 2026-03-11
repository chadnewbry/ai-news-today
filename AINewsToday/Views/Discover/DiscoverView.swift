import SwiftUI

struct DiscoverView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Listen") {
                    NavigationLink {
                        AudioBriefingsView()
                    } label: {
                        Label("Audio Briefings", systemImage: "headphones")
                    }
                }

                Section("Track") {
                    NavigationLink {
                        ModelTrackerView()
                    } label: {
                        Label("AI Model Tracker", systemImage: "cpu")
                    }

                    NavigationLink {
                        FundingTrackerView()
                    } label: {
                        Label("Funding Tracker", systemImage: "chart.line.uptrend.xyaxis")
                    }
                }

                Section("Read") {
                    NavigationLink {
                        ResearchDigestView()
                    } label: {
                        Label("Research Digest", systemImage: "doc.text.magnifyingglass")
                    }

                    NavigationLink {
                        BookmarksView()
                    } label: {
                        Label("Bookmarks", systemImage: "bookmark.fill")
                    }
                }
            }
            .navigationTitle("Discover")
        }
        .accessibilityIdentifier("discoverTab")
    }
}

#Preview {
    DiscoverView()
}
