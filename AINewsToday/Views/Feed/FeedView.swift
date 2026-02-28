import SwiftUI
import SwiftData

struct FeedView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FeedViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView("Loading articles…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.articles.isEmpty {
                    ContentUnavailableView(
                        "No Articles Yet",
                        systemImage: "newspaper",
                        description: Text("Pull down to fetch the latest AI news.")
                    )
                } else {
                    articleList
                }
            }
            .navigationTitle("Today's Feed")
            .refreshable {
                await viewModel.refresh(context: modelContext)
            }
            .task {
                viewModel.loadArticles(from: modelContext)
                if viewModel.articles.isEmpty {
                    await viewModel.refresh(context: modelContext)
                }
            }
            .overlay(alignment: .bottom) {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom, 8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    private var articleList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.articles) { article in
                    NavigationLink(value: article) {
                        ArticleCardView(article: article)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationDestination(for: Article.self) { article in
            ArticleDetailView(article: article)
        }
    }
}

#Preview {
    FeedView()
        .modelContainer(for: Article.self, inMemory: true)
}
