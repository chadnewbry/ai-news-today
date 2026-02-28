import Foundation
import SwiftData

/// Coordinates data fetching from the API with local SwiftData caching.
@MainActor
@Observable
final class NewsRepository {
    private let api = APIClient.shared
    private let persistence = PersistenceService.shared

    private(set) var isLoading = false
    private(set) var lastError: Error?

    /// Fetches articles, using cached data when fresh and forcing a network
    /// request otherwise. Pass `forceRefresh: true` to bypass the cache.
    func fetchArticles(
        topics: [String] = ["AI"],
        forceRefresh: Bool = false,
        context: ModelContext
    ) async {
        isLoading = true
        lastError = nil

        defer { isLoading = false }

        do {
            // Purge stale articles on each fetch cycle
            try persistence.purgeStaleArticles(in: context)

            let cacheFresh = try persistence.isCacheFresh(in: context)
            guard forceRefresh || !cacheFresh else { return }

            let dtos = try await api.fetchArticles(topics: topics)
            try persistence.importArticles(dtos, into: context)
        } catch {
            lastError = error
        }
    }
}
