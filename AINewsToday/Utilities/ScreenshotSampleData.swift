import Foundation
import SwiftData

#if DEBUG
enum ScreenshotSampleData {
    static var isScreenshotMode: Bool {
        ProcessInfo.processInfo.arguments.contains("--screenshot-mode")
    }

    @MainActor
    static func populate(context: ModelContext) {
        guard isScreenshotMode else { return }

        // Clear existing data
        try? context.delete(model: Article.self)
        try? context.delete(model: Source.self)
        try? context.delete(model: UserPreferences.self)

        // Create sources
        let openAI = Source(name: "OpenAI Blog", url: "https://openai.com/blog")
        let deepMind = Source(name: "DeepMind", url: "https://deepmind.google")
        let techCrunch = Source(name: "TechCrunch AI", url: "https://techcrunch.com/category/artificial-intelligence")
        let arxiv = Source(name: "arXiv Highlights", url: "https://arxiv.org")
        let theVerge = Source(name: "The Verge", url: "https://theverge.com")

        let sources = [openAI, deepMind, techCrunch, arxiv, theVerge]
        sources.forEach { context.insert($0) }

        // Create articles with realistic AI news content
        let now = Date()
        let articles: [(String, String, String, String, Source)] = [
            (
                "GPT-5 Turbo Launches with Real-Time Reasoning",
                "OpenAI unveils GPT-5 Turbo with breakthrough chain-of-thought reasoning that runs 3x faster than previous models, setting new benchmarks across coding, math, and scientific tasks.",
                "AI Models",
                "https://openai.com/blog/gpt5-turbo",
                openAI
            ),
            (
                "Google DeepMind Achieves AGI Milestone in Protein Design",
                "AlphaFold 4 can now design novel proteins from scratch, accelerating drug discovery timelines from years to weeks. Researchers call it a 'paradigm shift' in computational biology.",
                "Research",
                "https://deepmind.google/alphafold4",
                deepMind
            ),
            (
                "Apple Intelligence Gets Major Upgrade in iOS 19",
                "Apple rolls out on-device AI agents that can book travel, manage finances, and coordinate schedules — all without sending data to the cloud.",
                "Industry",
                "https://techcrunch.com/apple-intelligence-ios19",
                techCrunch
            ),
            (
                "EU AI Act Enforcement Begins: What Companies Need to Know",
                "The European Union starts enforcing its landmark AI regulation today. Companies face fines up to 7% of global revenue for non-compliance with transparency and safety requirements.",
                "Policy",
                "https://theverge.com/eu-ai-act-enforcement",
                theVerge
            ),
            (
                "New Diffusion Transformer Generates Photorealistic Video in Seconds",
                "Researchers publish a new architecture combining diffusion models with transformers, producing cinema-quality 4K video from text prompts in under 10 seconds on consumer hardware.",
                "Research",
                "https://arxiv.org/abs/2026.04321",
                arxiv
            ),
            (
                "Anthropic Raises $8B at $120B Valuation",
                "The AI safety company closes its largest funding round yet, with plans to scale Claude across enterprise markets and invest in interpretability research.",
                "Funding",
                "https://techcrunch.com/anthropic-series-e",
                techCrunch
            ),
            (
                "Meta Open-Sources Llama 5 with 1T Parameters",
                "Meta releases its largest open-source model yet, matching proprietary systems on key benchmarks. The AI community celebrates a win for open research.",
                "AI Models",
                "https://techcrunch.com/meta-llama5",
                techCrunch
            ),
            (
                "Autonomous Coding Agent Passes Google L5 Interview",
                "An AI coding agent built on top of GPT-5 successfully completes a full Google senior engineer interview loop, sparking debate about the future of software engineering.",
                "Industry",
                "https://theverge.com/ai-coding-agent-interview",
                theVerge
            ),
        ]

        for (i, (title, summary, category, url, source)) in articles.enumerated() {
            let article = Article(
                title: title,
                summary: summary,
                content: summary,
                url: url,
                publishedAt: now.addingTimeInterval(TimeInterval(-i * 3600)),
                category: category,
                isBookmarked: i == 0 || i == 2,
                source: source
            )
            context.insert(article)
        }

        // Create user preferences
        let prefs = UserPreferences(
            selectedTopics: ["AI Models", "Research", "Industry", "Policy", "Funding"],
            refreshIntervalMinutes: 30,
            notificationsEnabled: true
        )
        context.insert(prefs)

        try? context.save()

        // Mark onboarding as completed
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
#endif
