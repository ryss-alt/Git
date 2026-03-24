import SwiftUI
import SwiftData

struct FlashcardStudyView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: FlashcardViewModel?

    var body: some View {
        Group {
            if let vm = viewModel {
                studyContent(vm: vm)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("学習")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel == nil {
                let vm = FlashcardViewModel(context: context)
                vm.loadDueCards()
                viewModel = vm
            }
        }
    }

    @ViewBuilder
    private func studyContent(vm: FlashcardViewModel) -> some View {
        if vm.sessionCompleted {
            SessionCompleteView(
                cardsReviewed: vm.cardQueue.count,
                onStudyMore: {
                    vm.loadDueCards()
                },
                onDone: { dismiss() }
            )
        } else if vm.cardQueue.isEmpty {
            NoDueCardsView(onDone: { dismiss() })
        } else {
            VStack(spacing: 0) {
                // Progress bar
                ProgressView(value: vm.progress)
                    .padding(.horizontal)
                    .padding(.top, 8)

                Text("\(vm.remainingCount) 枚残り")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                Spacer()

                if let card = vm.currentCard {
                    CardFlipView(
                        card: card,
                        isShowingAnswer: vm.isShowingAnswer,
                        onReveal: vm.revealAnswer
                    )
                    .frame(maxHeight: 420)
                }

                Spacer()

                // Reveal / rating buttons
                if !vm.isShowingAnswer {
                    Button {
                        vm.revealAnswer()
                    } label: {
                        Text("答えを見る")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                } else {
                    VStack(spacing: 10) {
                        Text("どれくらい覚えていましたか？")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        RatingButtonsView { quality in
                            vm.gradeCard(quality: quality)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

private struct SessionCompleteView: View {
    let cardsReviewed: Int
    let onStudyMore: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            Text("セッション完了！")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("\(cardsReviewed) 枚のカードを復習しました")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Button("さらに学習する", action: onStudyMore)
                .buttonStyle(.borderedProminent)
            Button("終了", action: onDone)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

private struct NoDueCardsView: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 64))
                .foregroundStyle(.indigo)
            Text("今日の復習は完了しています")
                .font(.title2)
                .fontWeight(.semibold)
            Text("次の復習予定カードが来るまでお待ちください。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button("戻る", action: onDone)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
