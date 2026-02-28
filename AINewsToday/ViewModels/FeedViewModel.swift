import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class FeedViewModel {
    var articles: [Article] = []
    var isLoading = false
    var errorMessage: String?

    private let apiClient = APIClient.shared
    private let persistence = PersistenceService.shared

    func loadArticles(from context: ModelContext) {
        let descriptor = FetchDescriptor<Article>(
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        do {
            articles = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load articles."
        }
    }

    func refresh(context: ModelContext) async {
        isLoading = true
        errorMessage = nil

        do {
            let dtos = try await apiClient.fetchArticles()
            try persistence.importArticles(dtos, into: context)
            loadArticles(from: context)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
