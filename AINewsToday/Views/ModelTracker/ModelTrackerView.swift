import SwiftUI

struct ModelTrackerView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "cpu")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                Text("AI Model Tracker")
                    .font(.title2.bold())
                Text("Track new model releases and benchmarks")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Models")
        }
        .accessibilityIdentifier("modelTrackerTab")
    }
}

#Preview {
    ModelTrackerView()
}
