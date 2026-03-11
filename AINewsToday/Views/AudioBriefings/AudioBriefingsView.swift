import SwiftUI

struct AudioBriefingsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "headphones")
                    .font(.system(size: 48))
                    .foregroundStyle(.purple)
                Text("Audio Briefings")
                    .font(.title2.bold())
                Text("Listen to AI news on the go")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Audio")
        }
        .accessibilityIdentifier("audioBriefingsTab")
    }
}

#Preview {
    AudioBriefingsView()
}
