import SwiftUI
import SwiftData

@main
struct ChineseLearningApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: VocabularyCard.self, StudySession.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .modelContainer(container)
                .onAppear {
                    SeedDataLoader.loadIfNeeded(context: container.mainContext)
                }
        }
    }
}
