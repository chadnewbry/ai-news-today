import Foundation
import SwiftData

@Model
final class Source {
    @Attribute(.unique) var id: String
    var name: String
    var url: String
    var iconURL: String?
    var isEnabled: Bool

    @Relationship(deleteRule: .cascade, inverse: \Article.source)
    var articles: [Article]

    init(
        id: String = UUID().uuidString,
        name: String,
        url: String,
        iconURL: String? = nil,
        isEnabled: Bool = true,
        articles: [Article] = []
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.iconURL = iconURL
        self.isEnabled = isEnabled
        self.articles = articles
    }
}
