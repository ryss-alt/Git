import Foundation
import SwiftData

@Model
final class VocabularyCard {
    var id: UUID
    var word: String
    var pinyin: String
    var meaning: String
    var exampleSentence: String
    var exampleTranslation: String
    var category: String
    var hskLevel: Int

    // SRS fields
    var easeFactor: Double
    var interval: Int
    var repetitions: Int
    var dueDate: Date
    var isLearned: Bool
    var createdAt: Date
    var lastReviewedAt: Date?

    init(
        word: String,
        pinyin: String,
        meaning: String,
        exampleSentence: String = "",
        exampleTranslation: String = "",
        category: String,
        hskLevel: Int
    ) {
        self.id = UUID()
        self.word = word
        self.pinyin = pinyin
        self.meaning = meaning
        self.exampleSentence = exampleSentence
        self.exampleTranslation = exampleTranslation
        self.category = category
        self.hskLevel = hskLevel
        self.easeFactor = 2.5
        self.interval = 0
        self.repetitions = 0
        self.dueDate = Date()
        self.isLearned = false
        self.createdAt = Date()
        self.lastReviewedAt = nil
    }
}
