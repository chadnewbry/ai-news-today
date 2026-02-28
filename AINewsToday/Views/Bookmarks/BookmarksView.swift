import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Query(filter: #Predicate<Article> { $0.isBookmarked },
           sort: \Article.publishedAt, order: .reverse)
    private var bookmarkedArticles: [Article]

    @State private var selectedArticle: Article?

    var body: some View {
        NavigationStack {
            Group {
                if bookmarkedArticles.isEmpty {
                    ContentUnavailableView(
                        "No Bookmarks Yet",
                        systemImage: "bookmark",
                        description: Text("Tap the bookmark icon on any article to save it here.")
                    )
                } else {
                    List {
                        ForEach(bookmarkedArticles) { article in
                            Button {
                                selectedArticle = article
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    if let source = article.source {
                                        Text(source.name.uppercased())
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Text(article.title)
                                        .font(.subheadline.weight(.semibold))
                                        .lineLimit(2)
                                    Text(article.publishedAt, style: .relative)
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    article.isBookmarked = false
                                } label: {
                                    Label("Remove", systemImage: "bookmark.slash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .navigationDestination(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
        }
    }
}

#Preview {
    BookmarksView()
        .modelContainer(for: Article.self, inMemory: true)
}
