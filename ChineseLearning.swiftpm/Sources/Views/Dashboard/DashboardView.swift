import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @State private var viewModel: StudyDashboardViewModel?
    @State private var navigateToStudy = false

    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    dashboardContent(vm: vm)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("ダッシュボード")
            .navigationDestination(isPresented: $navigateToStudy) {
                FlashcardStudyView()
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = StudyDashboardViewModel(context: context)
                }
                viewModel?.refresh()
            }
        }
    }

    @ViewBuilder
    private func dashboardContent(vm: StudyDashboardViewModel) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // Today's task card
                TodayTaskCard(dueCount: vm.dueTodayCount) {
                    navigateToStudy = true
                }

                // Stats row
                StatsRowView(
                    streakDays: vm.streakDays,
                    totalLearned: vm.totalLearnedCount,
                    totalStudyTime: vm.totalStudyHours
                )

                // Weekly chart
                if !vm.weeklyData.isEmpty {
                    WeeklyChartView(data: vm.weeklyData)
                }
            }
            .padding()
        }
        .refreshable {
            vm.refresh()
        }
    }
}

private struct TodayTaskCard: View {
    let dueCount: Int
    let onStudy: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("今日の復習")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("\(dueCount) 枚")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(dueCount > 0 ? .primary : .secondary)
                }
                Spacer()
                Image(systemName: dueCount > 0 ? "rectangle.stack.fill" : "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(dueCount > 0 ? Color.accentColor : .green)
            }

            if dueCount > 0 {
                Button(action: onStudy) {
                    Label("今すぐ学習する", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Text("今日の復習はすべて完了しています")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct StatsRowView: View {
    let streakDays: Int
    let totalLearned: Int
    let totalStudyTime: String

    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                value: "\(streakDays)日",
                label: "連続学習",
                icon: "flame.fill",
                color: .orange
            )
            StatCard(
                value: "\(totalLearned)語",
                label: "習得済み",
                icon: "checkmark.circle.fill",
                color: .green
            )
            StatCard(
                value: totalStudyTime,
                label: "累計時間",
                icon: "clock.fill",
                color: .blue
            )
        }
    }
}

private struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct WeeklyChartView: View {
    let data: [(date: Date, count: Int)]

    private var maxCount: Int {
        max(data.map(\.count).max() ?? 1, 10)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("今週の学習カード数")
                .font(.headline)

            Chart(data, id: \.date) { item in
                BarMark(
                    x: .value("日付", item.date, unit: .day),
                    y: .value("枚数", item.count)
                )
                .foregroundStyle(Color.accentColor.gradient)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 180)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
