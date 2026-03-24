import Foundation
import SwiftData
import SwiftUI

@Observable
final class FlashcardViewModel {
    private let context: ModelContext

    var cardQueue: [VocabularyCard] = []
    var currentIndex: Int = 0
    var isShowingAnswer: Bool = false
    var sessionCompleted: Bool = false

    // Session tracking
    private var sessionStartTime: Date = Date()
    private var cardsReviewed: Int = 0
    private var cardsLearned: Int = 0
    private var correctAnswers: Int = 0

    var currentCard: VocabularyCard? {
        guard currentIndex < cardQueue.count else { return nil }
        return cardQueue[currentIndex]
    }

    var progress: Double {
        guard !cardQueue.isEmpty else { return 0 }
        return Double(currentIndex) / Double(cardQueue.count)
    }

    var remainingCount: Int {
        max(0, cardQueue.count - currentIndex)
    }

    init(context: ModelContext) {
        self.context = context
    }

    func loadDueCards() {
        let now = Date()
        let descriptor = FetchDescriptor<VocabularyCard>(
            predicate: #Predicate { card in
                card.dueDate <= now
            },
            sortBy: [SortDescriptor(\.dueDate)]
        )
        do {
            let allDue = try context.fetch(descriptor)
            // Limit to 20 cards per session to avoid overwhelming
            cardQueue = Array(allDue.prefix(20))
            currentIndex = 0
            isShowingAnswer = false
            sessionCompleted = false
            sessionStartTime = Date()
            cardsReviewed = 0
            cardsLearned = 0
            correctAnswers = 0
        } catch {
            print("FlashcardViewModel: Failed to fetch due cards: \(error)")
        }
    }

    func revealAnswer() {
        isShowingAnswer = true
    }

    func gradeCard(quality: SRSEngine.Quality) {
        guard let card = currentCard else { return }

        let wasLearned = card.isLearned
        SRSEngine.applyReview(to: card, quality: quality)
        cardsReviewed += 1

        if quality.rawValue >= 3 {
            correctAnswers += 1
        }
        if !wasLearned && card.isLearned {
            cardsLearned += 1
        }

        do {
            try context.save()
        } catch {
            print("FlashcardViewModel: Failed to save card: \(error)")
        }

        advanceToNext()
    }

    private func advanceToNext() {
        if currentIndex + 1 >= cardQueue.count {
            finishSession()
        } else {
            currentIndex += 1
            isShowingAnswer = false
        }
    }

    private func finishSession() {
        guard cardsReviewed > 0 else {
            sessionCompleted = true
            return
        }
        let duration = Int(Date().timeIntervalSince(sessionStartTime))
        let session = StudySession(
            date: Date(),
            cardsReviewed: cardsReviewed,
            cardsLearned: cardsLearned,
            studyDurationSeconds: duration,
            correctAnswers: correctAnswers,
            totalAnswers: cardsReviewed
        )
        context.insert(session)
        do {
            try context.save()
        } catch {
            print("FlashcardViewModel: Failed to save session: \(error)")
        }
        sessionCompleted = true
    }

    func dueTodayCount() -> Int {
        let now = Date()
        let descriptor = FetchDescriptor<VocabularyCard>(
            predicate: #Predicate { card in
                card.dueDate <= now
            }
        )
        return (try? context.fetchCount(descriptor)) ?? 0
    }
}
