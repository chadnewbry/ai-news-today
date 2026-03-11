import SwiftUI

struct FundingTrackerView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 48))
                    .foregroundStyle(.green)
                Text("Funding Tracker")
                    .font(.title2.bold())
                Text("AI startup funding rounds and deals")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Funding")
        }
        .accessibilityIdentifier("fundingTrackerTab")
    }
}

#Preview {
    FundingTrackerView()
}
