import Foundation

/// Known article categories for AI news.
enum ArticleCategory: String, CaseIterable, Codable, Identifiable {
    case general = "General"
    case research = "Research"
    case industry = "Industry"
    case policy = "Policy"
    case tools = "Tools"
    case machinelearning = "Machine Learning"
    case robotics = "Robotics"
    case ethics = "Ethics"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var systemImage: String {
        switch self {
        case .general: "newspaper"
        case .research: "doc.text.magnifyingglass"
        case .industry: "building.2"
        case .policy: "building.columns"
        case .tools: "wrench.and.screwdriver"
        case .machinelearning: "brain"
        case .robotics: "figure.walk"
        case .ethics: "scale.3d"
        }
    }
}
