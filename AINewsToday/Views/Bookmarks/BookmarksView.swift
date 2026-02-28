import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Query(
        filter: #Predicate<Article> { $0.isBookmarked },
        sort: \Article.publishedAt,
        order: .reverse
    ) private var bookmarkedArticles: [Article]

    var body: some View {
        NavigationStack {
            Group {
                if bookmarkedArticles.isEmpty {
                    ContentUnavailableView(
                        "No Bookmarks Yet",
                        systemImage: "bookmark",
                        description: Text("Articles you bookmark will appear here.")
                    )
                } else {
                    List(bookmarkedArticles) { article in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(article.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(article.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 2)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Bookmarks")
        }
    }
}

#Preview {
    BookmarksView()
        .modelContainer(for: Article.self, inMemory: true)
}
