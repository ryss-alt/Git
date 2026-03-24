import Foundation
import SwiftData
import SwiftUI

@Observable
final class StudyDashboardViewModel {
    private let context: ModelContext

    var dueTodayCount: Int = 0
    var totalLearnedCount: Int = 0
    var streakDays: Int = 0
    var totalStudySeconds: Int = 0
    var weeklyData: [(date: Date, count: Int)] = []

    var totalStudyHours: String {
        let hours = totalStudySeconds / 3600
        let minutes = (totalStudySeconds % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    init(context: ModelContext) {
        self.context = context
    }

    func refresh() {
        loadDueTodayCount()
        loadTotalLearned()
        loadStreak()
        loadWeeklyData()
    }

    private func loadDueTodayCount() {
        let now = Date()
        let descriptor = FetchDescriptor<VocabularyCard>(
            predicate: #Predicate { card in
                card.dueDate <= now
            }
        )
        dueTodayCount = (try? context.fetchCount(descriptor)) ?? 0
    }

    private func loadTotalLearned() {
        let descriptor = FetchDescriptor<VocabularyCard>(
            predicate: #Predicate { card in
                card.isLearned == true
            }
        )
        totalLearnedCount = (try? context.fetchCount(descriptor)) ?? 0
    }

    private func loadStreak() {
        let descriptor = FetchDescriptor<StudySession>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        guard let sessions = try? context.fetch(descriptor) else {
            streakDays = 0
            totalStudySeconds = 0
            return
        }

        totalStudySeconds = sessions.reduce(0) { $0 + $1.studyDurationSeconds }

        // Build set of dates with sessions
        let calendar = Calendar.current
        let sessionDates = Set(sessions.map { calendar.startOfDay(for: $0.date) })

        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())

        // Always count today or yesterday as streak start
        while sessionDates.contains(checkDate) {
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }

        streakDays = streak
    }

    private func loadWeeklyData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekStart = calendar.date(byAdding: .day, value: -6, to: today) else { return }

        let descriptor = FetchDescriptor<StudySession>(
            predicate: #Predicate { session in
                session.date >= weekStart
            }
        )
        guard let sessions = try? context.fetch(descriptor) else {
            weeklyData = []
            return
        }

        // Group by day
        var grouped: [Date: Int] = [:]
        for session in sessions {
            let day = calendar.startOfDay(for: session.date)
            grouped[day, default: 0] += session.cardsReviewed
        }

        weeklyData = (0...6).compactMap { offset -> (date: Date, count: Int)? in
            guard let date = calendar.date(byAdding: .day, value: offset - 6, to: today) else { return nil }
            let day = calendar.startOfDay(for: date)
            return (date: day, count: grouped[day] ?? 0)
        }
    }
}
