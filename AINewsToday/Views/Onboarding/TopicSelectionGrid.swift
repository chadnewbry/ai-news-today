import SwiftUI

struct TopicSelectionGrid: View {
    @Binding var selectedTopics: Set<String>

    static let availableTopics = [
        "AI", "Machine Learning", "Robotics", "LLMs",
        "Computer Vision", "NLP", "AI Ethics", "Startups",
        "Research", "Autonomous Vehicles", "Healthcare AI", "AI Policy"
    ]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Self.availableTopics, id: \.self) { topic in
                TopicChip(
                    title: topic,
                    isSelected: selectedTopics.contains(topic)
                ) {
                    if selectedTopics.contains(topic) {
                        selectedTopics.remove(topic)
                    } else {
                        selectedTopics.insert(topic)
                    }
                }
            }
        }
    }
}

private struct TopicChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

#Preview {
    TopicSelectionGrid(selectedTopics: .constant(["AI", "Robotics"]))
        .padding()
}
