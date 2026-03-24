import Foundation
import SwiftData

@Model
final class StudySession {
    var id: UUID
    var date: Date
    var cardsReviewed: Int
    var cardsLearned: Int
    var studyDurationSeconds: Int
    var correctAnswers: Int
    var totalAnswers: Int

    init(
        date: Date = Date(),
        cardsReviewed: Int = 0,
        cardsLearned: Int = 0,
        studyDurationSeconds: Int = 0,
        correctAnswers: Int = 0,
        totalAnswers: Int = 0
    ) {
        self.id = UUID()
        self.date = date
        self.cardsReviewed = cardsReviewed
        self.cardsLearned = cardsLearned
        self.studyDurationSeconds = studyDurationSeconds
        self.correctAnswers = correctAnswers
        self.totalAnswers = totalAnswers
    }
}
