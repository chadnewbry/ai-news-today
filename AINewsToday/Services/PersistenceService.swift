import Foundation
import SwiftData

/// Manages SwiftData persistence operations.
@MainActor
final class PersistenceService {
    static let shared = PersistenceService()

    let container: ModelContainer

    /// How long cached articles remain fresh before a refresh is needed.
    static let cacheExpirationInterval: TimeInterval = 30 * 60 // 30 minutes

    /// Maximum age for non-bookmarked articles before purge.
    static let articleRetentionInterval: TimeInterval = 7 * 24 * 60 * 60 // 7 days

    private init() {
        let schema = Schema([
            Article.self,
            Source.self,
            UserPreferences.self
        ])

        let config = ModelConfiguration(
            "AINewsToday",
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // MARK: - Article Import

    /// Imports articles from DTOs, upserting by ID.
    func importArticles(_ dtos: [ArticleDTO], into context: ModelContext) throws {
        let now = Date.now

        for dto in dtos {
            let id = dto.id
            let descriptor = FetchDescriptor<Article>(
                predicate: #Predicate { $0.id == id }
            )
            let existing = try context.fetch(descriptor)

            if let article = existing.first {
                // Update existing article
                article.title = dto.title
                article.summary = dto.summary
                article.category = dto.category ?? "General"
                article.cachedAt = now
            } else {
                let source = try findOrCreateSource(
                    name: dto.sourceName,
                    url: dto.sourceURL,
                    in: context
                )

                let article = Article(
                    id: dto.id,
                    title: dto.title,
                    summary: dto.summary,
                    url: dto.url,
                    imageURL: dto.imageURL,
                    publishedAt: dto.publishedAt ?? .now,
                    category: dto.category ?? "General",
                    source: source,
                    cachedAt: now
                )
                context.insert(article)
            }
        }

        try context.save()
    }

    // MARK: - Cache Management

    /// Returns true if the cache has fresh articles (not expired).
    func isCacheFresh(in context: ModelContext) throws -> Bool {
        let cutoff = Date.now.addingTimeInterval(-Self.cacheExpirationInterval)
        let descriptor = FetchDescriptor<Article>(
            predicate: #Predicate { $0.cachedAt > cutoff }
        )
        let count = try context.fetchCount(descriptor)
        return count > 0
    }

    /// Purges non-bookmarked articles older than the retention interval.
    func purgeStaleArticles(in context: ModelContext) throws {
        let cutoff = Date.now.addingTimeInterval(-Self.articleRetentionInterval)
        let descriptor = FetchDescriptor<Article>(
            predicate: #Predicate { $0.cachedAt < cutoff && !$0.isBookmarked }
        )
        let stale = try context.fetch(descriptor)
        for article in stale {
            context.delete(article)
        }
        if !stale.isEmpty {
            try context.save()
        }
    }

    // MARK: - Sources

    private func findOrCreateSource(
        name: String,
        url: String,
        in context: ModelContext
    ) throws -> Source {
        let descriptor = FetchDescriptor<Source>(
            predicate: #Predicate { $0.name == name }
        )
        if let existing = try context.fetch(descriptor).first {
            return existing
        }

        let source = Source(name: name, url: url)
        context.insert(source)
        return source
    }

    // MARK: - User Preferences

    /// Returns or creates the default user preferences.
    func getPreferences(from context: ModelContext) throws -> UserPreferences {
        let descriptor = FetchDescriptor<UserPreferences>()
        if let existing = try context.fetch(descriptor).first {
            return existing
        }

        let prefs = UserPreferences()
        context.insert(prefs)
        try context.save()
        return prefs
    }
}
