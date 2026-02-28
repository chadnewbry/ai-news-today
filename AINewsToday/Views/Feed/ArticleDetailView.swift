import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.openURL) private var openURL

    private var articleURL: URL? {
        URL(string: article.url)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: 250)
                                .clipped()
                        default:
                            EmptyView()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    if let source = article.source {
                        Text(source.name.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                    }

                    Text(article.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(article.publishedAt, format: .dateTime.month().day().year().hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Divider()

                    Text(article.summary)
                        .font(.body)
                        .lineSpacing(4)

                    if !article.content.isEmpty {
                        Text(article.content)
                            .font(.body)
                            .lineSpacing(4)
                    }

                    if let url = articleURL {
                        Button {
                            openURL(url)
                        } label: {
                            Label("Read Full Article", systemImage: "safari")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let url = articleURL {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    article.isBookmarked.toggle()
                } label: {
                    Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(article: Article(
            title: "OpenAI Announces GPT-5",
            summary: "A groundbreaking new model with improved reasoning capabilities across all benchmarks.",
            content: "OpenAI has released GPT-5, their latest large language model...",
            url: "https://example.com",
            publishedAt: .now
        ))
    }
}
