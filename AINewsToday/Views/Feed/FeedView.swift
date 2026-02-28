import SwiftUI
import SwiftData

struct FeedView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Article.publishedAt, order: .reverse) private var articles: [Article]
    @State private var repository = NewsRepository()

    var body: some View {
        NavigationStack {
            Group {
                if articles.isEmpty && !repository.isLoading {
                    ContentUnavailableView(
                        "No Articles Yet",
                        systemImage: "newspaper",
                        description: Text("Pull to refresh or tap below to load today's AI news.")
                    )
                } else {
                    articleList
                }
            }
            .navigationTitle("Today's Feed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if repository.isLoading {
                        ProgressView()
                    }
                }
            }
            .refreshable {
                await repository.fetchArticles(forceRefresh: true, context: modelContext)
            }
            .task {
                await repository.fetchArticles(context: modelContext)
            }
        }
    }

    private var articleList: some View {
        List(articles) { article in
            ArticleRowView(article: article)
        }
        .listStyle(.plain)
    }
}

// MARK: - Article Row

private struct ArticleRowView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if let sourceName = article.source?.name {
                    Text(sourceName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(article.category)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.fill.tertiary, in: Capsule())
            }

            Text(article.title)
                .font(.headline)
                .lineLimit(2)

            Text(article.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            Text(article.publishedAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FeedView()
        .modelContainer(for: Article.self, inMemory: true)
}
