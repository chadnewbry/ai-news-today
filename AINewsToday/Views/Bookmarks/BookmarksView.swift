import SwiftUI

struct BookmarksView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Bookmarks Yet",
                systemImage: "bookmark",
                description: Text("Articles you bookmark will appear here.")
            )
            .navigationTitle("Bookmarks")
        }
    }
}

#Preview {
    BookmarksView()
}
