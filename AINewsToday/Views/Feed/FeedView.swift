import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Coming Soon",
                systemImage: "newspaper",
                description: Text("Your AI-curated news feed will appear here.")
            )
            .navigationTitle("Today's Feed")
        }
    }
}

#Preview {
    FeedView()
}
