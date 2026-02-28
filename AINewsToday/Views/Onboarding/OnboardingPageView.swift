import SwiftUI

struct OnboardingPageView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(iconColor)

            Text(title)
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
    }
}

#Preview {
    OnboardingPageView(
        icon: "newspaper.fill",
        iconColor: .accentColor,
        title: "Welcome",
        subtitle: "Your AI news feed awaits."
    )
}
