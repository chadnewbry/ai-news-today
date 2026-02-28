import SwiftUI
import SwiftData

struct FeedView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = FeedViewModel()
    @State private var showPaywall = false
    @State private var selectedArticle: Article?
    private var storeManager = StoreManager.shared
    private var usageManager = UsageManager.shared

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.articles.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "Coming Soon",
                        systemImage: "newspaper",
                        description: Text("Your AI-curated news feed will appear here.")
                    )
                } else {
                    articleList
                }
            }
            .navigationTitle("Today's Feed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    usageIndicator
                }
            }
            .refreshable {
                await viewModel.refresh(context: modelContext)
            }
            .onAppear { viewModel.loadArticles(from: modelContext) }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .navigationDestination(item: $selectedArticle) { article in
                ArticleDetailView(article: article)
            }
        }
    }

    private var articleList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.articles) { article in
                    ArticleCardView(article: article)
                        .onTapGesture { handleArticleTap(article) }
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private var usageIndicator: some View {
        if storeManager.isProUser {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
        } else {
            HStack(spacing: 6) {
                Text("\(usageManager.freeUsesRemaining) free")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button {
                    showPaywall = true
                } label: {
                    Text("Upgrade")
                        .font(.caption.bold())
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.mini)
            }
        }
    }

    private func handleArticleTap(_ article: Article) {
        if storeManager.isProUser || usageManager.recordUse(isPro: false) {
            selectedArticle = article
        } else {
            showPaywall = true
        }
    }
}

#Preview {
    FeedView()
}
