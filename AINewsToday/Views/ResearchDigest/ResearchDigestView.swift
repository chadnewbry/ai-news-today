import SwiftUI

struct ResearchDigestView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 48))
                    .foregroundStyle(.indigo)
                Text("Research Digest")
                    .font(.title2.bold())
                Text("Summaries of the latest AI/ML papers")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Research")
        }
        .accessibilityIdentifier("researchDigestTab")
    }
}

#Preview {
    ResearchDigestView()
}
