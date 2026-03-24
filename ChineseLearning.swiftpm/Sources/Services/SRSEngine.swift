import Foundation

/// SM-2 Spaced Repetition System implementation as pure functions.
/// Reference: https://www.supermemo.com/en/blog/application-of-a-computer-to-improve-the-results-obtained-in-working-with-the-supermemo-method
enum SRSEngine {

    struct ReviewResult {
        let newRepetitions: Int
        let newEaseFactor: Double
        let newInterval: Int
        let dueDate: Date
    }

    /// Quality ratings mapped to SM-2 quality values (0–5).
    enum Quality: Int, CaseIterable {
        case again = 1   // 全く覚えていない
        case hard  = 2   // 少し思い出せた
        case good  = 4   // 頑張れば思い出せた
        case easy  = 5   // すぐ思い出せた

        var displayName: String {
            switch self {
            case .again: return "もう一回"
            case .hard:  return "難しい"
            case .good:  return "普通"
            case .easy:  return "簡単"
            }
        }

        var color: String {
            switch self {
            case .again: return "red"
            case .hard:  return "orange"
            case .good:  return "green"
            case .easy:  return "blue"
            }
        }
    }

    /// Calculates the next review schedule using the SM-2 algorithm.
    /// - Parameters:
    ///   - repetitions: Number of consecutive correct reviews
    ///   - easeFactor: Current ease factor (min 1.3)
    ///   - interval: Current interval in days
    ///   - quality: User-rated quality (0–5)
    /// - Returns: Updated SRS parameters and next due date
    static func calculateNextReview(
        repetitions: Int,
        easeFactor: Double,
        interval: Int,
        quality: Quality
    ) -> ReviewResult {
        let q = quality.rawValue

        let newEaseFactor = max(
            1.3,
            easeFactor + 0.1 - Double(5 - q) * (0.08 + Double(5 - q) * 0.02)
        )

        let newRepetitions: Int
        let newInterval: Int

        if q < 3 {
            // Failed recall — reset
            newRepetitions = 0
            newInterval = 1
        } else {
            newRepetitions = repetitions + 1
            switch repetitions {
            case 0:
                newInterval = 1
            case 1:
                newInterval = 6
            default:
                newInterval = Int(round(Double(interval) * easeFactor))
            }
        }

        let dueDate = Calendar.current.date(
            byAdding: .day,
            value: newInterval,
            to: Date()
        ) ?? Date()

        return ReviewResult(
            newRepetitions: newRepetitions,
            newEaseFactor: newEaseFactor,
            newInterval: newInterval,
            dueDate: dueDate
        )
    }

    /// Applies a review result to a VocabularyCard in place.
    static func applyReview(to card: VocabularyCard, quality: Quality) {
        let result = calculateNextReview(
            repetitions: card.repetitions,
            easeFactor: card.easeFactor,
            interval: card.interval,
            quality: quality
        )
        card.repetitions = result.newRepetitions
        card.easeFactor = result.newEaseFactor
        card.interval = result.newInterval
        card.dueDate = result.dueDate
        card.lastReviewedAt = Date()

        // Mark as learned after first successful interval >= 21 days
        if result.newInterval >= 21 {
            card.isLearned = true
        }
    }
}
