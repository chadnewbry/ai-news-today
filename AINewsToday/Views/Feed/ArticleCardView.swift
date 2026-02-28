import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let imageURL = article.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                    case .failure:
                        imagePlaceholder
                    case .empty:
                        ProgressView()
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        imagePlaceholder
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 6) {
                if let source = article.source {
                    Text(source.name.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }

                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)

                Text(article.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(article.publishedAt, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }

    private var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.quaternary)
            .frame(height: 180)
            .overlay {
                Image(systemName: "newspaper")
                    .font(.largeTitle)
                    .foregroundStyle(.tertiary)
            }
    }
}

#Preview {
    ArticleCardView(article: Article(
        title: "OpenAI Announces GPT-5 with Breakthrough Reasoning",
        summary: "The latest model shows significant improvements in multi-step reasoning and code generation capabilities.",
        url: "https://example.com",
        publishedAt: .now.addingTimeInterval(-3600)
    ))
    .padding()
}
