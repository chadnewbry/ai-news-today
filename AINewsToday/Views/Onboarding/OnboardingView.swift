import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var hasCompletedOnboarding: Bool

    @State private var currentPage = 0
    @State private var selectedTopics: Set<String> = []
    @State private var notificationManager = NotificationManager.shared

    private let totalPages = 4

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                welcomePage.tag(0)
                featuresPage.tag(1)
                topicSelectionPage.tag(2)
                notificationsPage.tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            bottomBar
        }
        .background(Color(.systemBackground))
    }

    // MARK: - Pages

    private var welcomePage: some View {
        OnboardingPageView(
            icon: "newspaper.fill",
            iconColor: .accentColor,
            title: "Welcome to AI News Today",
            subtitle: "Your daily dose of AI news, curated and summarized just for you."
        )
    }

    private var featuresPage: some View {
        OnboardingPageView(
            icon: "sparkles",
            iconColor: .purple,
            title: "AI-Curated Feed",
            subtitle: "We use AI to find, summarize, and organize the most important stories in artificial intelligence — so you don't have to."
        )
    }

    private var topicSelectionPage: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "text.badge.checkmark")
                .font(.system(size: 56))
                .foregroundStyle(.orange)

            Text("Pick Your Topics")
                .font(.title.bold())

            Text("Choose the areas you care about. We'll tailor your feed accordingly.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            TopicSelectionGrid(selectedTopics: $selectedTopics)
                .padding(.horizontal, 24)

            Spacer()
        }
    }

    private var notificationsPage: some View {
        OnboardingPageView(
            icon: "bell.badge.fill",
            iconColor: .red,
            title: "Stay in the Loop",
            subtitle: "Enable notifications to get a daily digest of the top AI stories, delivered right when you want it."
        )
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }

            Button {
                handleAction()
            } label: {
                Text(buttonTitle)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)
            .disabled(currentPage == 2 && selectedTopics.isEmpty)
        }
        .padding(.bottom, 32)
        .padding(.top, 12)
    }

    private var buttonTitle: String {
        switch currentPage {
        case 3: return "Get Started"
        case 2: return selectedTopics.isEmpty ? "Select at Least One" : "Continue"
        default: return "Continue"
        }
    }

    // MARK: - Actions

    private func handleAction() {
        if currentPage == 3 {
            completeOnboarding()
        } else if currentPage == 2 {
            currentPage = 3
            Task {
                _ = await notificationManager.requestAuthorization()
            }
        } else {
            currentPage += 1
        }
    }

    private func completeOnboarding() {
        do {
            let prefs = try PersistenceService.shared.getPreferences(from: modelContext)
            prefs.selectedTopics = Array(selectedTopics)
            try modelContext.save()
        } catch {
            // Proceed anyway
        }
        hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
        .modelContainer(PersistenceService.shared.container)
}
