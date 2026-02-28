import Foundation
import SwiftData

@Model
final class Article {
    @Attribute(.unique) var id: String
    var title: String
    var summary: String
    var content: String
    var url: String
    var imageURL: String?
    var publishedAt: Date
    var category: String
    var isBookmarked: Bool
    var source: Source?
    var cachedAt: Date

    init(
        id: String = UUID().uuidString,
        title: String,
        summary: String,
        content: String = "",
        url: String,
        imageURL: String? = nil,
        publishedAt: Date = .now,
        category: String = "General",
        isBookmarked: Bool = false,
        source: Source? = nil,
        cachedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.url = url
        self.imageURL = imageURL
        self.publishedAt = publishedAt
        self.category = category
        self.isBookmarked = isBookmarked
        self.source = source
        self.cachedAt = cachedAt
    }
}
