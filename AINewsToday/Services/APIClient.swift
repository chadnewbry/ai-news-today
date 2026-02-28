import Foundation

/// API client for fetching AI news articles.
/// Uses the OpenAI proxy for AI-powered news curation.
actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let proxyURL = URL(string: "https://realidcheck-proxy.chadnewbry.workers.dev")!

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - News Fetching

    /// Fetches the latest AI news articles.
    func fetchArticles(topics: [String] = ["AI"]) async throws -> [ArticleDTO] {
        let prompt = """
        Return the top 10 latest AI news stories as a JSON array. Each item should have:
        - "id": unique string
        - "title": headline
        - "summary": 2-3 sentence summary
        - "url": source URL
        - "source_name": publisher name
        - "source_url": publisher homepage
        - "published_at": ISO 8601 date string
        - "image_url": image URL or null
        - "category": one of "General", "Research", "Industry", "Policy", "Tools", "Machine Learning", "Robotics", "Ethics"
        Topics of interest: \(topics.joined(separator: ", "))
        Respond with ONLY the JSON array, no markdown.
        """

        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "You are a news API that returns structured JSON data about AI news."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 4000,
            "temperature": 0.3
        ]

        var request = URLRequest(url: proxyURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.requestFailed
        }

        let chatResponse = try decoder.decode(ChatCompletionResponse.self, from: data)
        guard let content = chatResponse.choices.first?.message.content else {
            throw APIError.noContent
        }

        // Parse the JSON array from the response content
        let cleanedContent = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = cleanedContent.data(using: .utf8) else {
            throw APIError.decodingFailed
        }

        return try decoder.decode([ArticleDTO].self, from: jsonData)
    }
}

// MARK: - DTOs

struct ArticleDTO: Codable {
    let id: String
    let title: String
    let summary: String
    let url: String
    let sourceName: String
    let sourceURL: String
    let publishedAt: Date?
    let imageURL: String?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case id, title, summary, url, category
        case sourceName = "source_name"
        case sourceURL = "source_url"
        case publishedAt = "published_at"
        case imageURL = "image_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        summary = try container.decode(String.self, forKey: .summary)
        url = try container.decode(String.self, forKey: .url)
        sourceName = try container.decode(String.self, forKey: .sourceName)
        sourceURL = try container.decode(String.self, forKey: .sourceURL)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        category = try container.decodeIfPresent(String.self, forKey: .category)

        if let dateString = try? container.decode(String.self, forKey: .publishedAt) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            publishedAt = formatter.date(from: dateString)
                ?? ISO8601DateFormatter().date(from: dateString)
        } else {
            publishedAt = nil
        }
    }
}

// MARK: - OpenAI Response Types

private struct ChatCompletionResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let content: String?
    }
}

// MARK: - Errors

enum APIError: LocalizedError {
    case requestFailed
    case noContent
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .requestFailed: "Network request failed"
        case .noContent: "No content in response"
        case .decodingFailed: "Failed to decode response"
        }
    }
}
