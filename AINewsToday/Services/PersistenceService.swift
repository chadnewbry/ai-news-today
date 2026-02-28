import Foundation
import SwiftData

/// Manages SwiftData persistence operations.
@MainActor
final class PersistenceService {
    static let shared = PersistenceService()

    let container: ModelContainer

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

    /// Imports articles from DTOs, upserting by ID.
    func importArticles(_ dtos: [ArticleDTO], into context: ModelContext) throws {
        for dto in dtos {
            let id = dto.id
            let descriptor = FetchDescriptor<Article>(
                predicate: #Predicate { $0.id == id }
            )
            let existing = try context.fetch(descriptor)

            if existing.isEmpty {
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
                    source: source
                )
                context.insert(article)
            }
        }

        try context.save()
    }

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
