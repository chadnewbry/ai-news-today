import SwiftUI

struct DailyBriefingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "sun.horizon.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.orange)
                Text("Daily Briefing")
                    .font(.title2.bold())
                Text("Your AI-curated daily news digest")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Daily Briefing")
        }
        .accessibilityIdentifier("dailyBriefingTab")
    }
}

#Preview {
    DailyBriefingView()
}
