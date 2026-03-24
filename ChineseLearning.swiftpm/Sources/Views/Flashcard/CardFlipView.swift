import SwiftUI

struct CardFlipView: View {
    let card: VocabularyCard
    let isShowingAnswer: Bool
    let onReveal: () -> Void

    @State private var frontRotation: Double = 0
    @State private var backRotation: Double = -90

    var body: some View {
        ZStack {
            // Back face (answer)
            CardFaceView(card: card, isFront: false)
                .rotation3DEffect(.degrees(backRotation), axis: (x: 0, y: 1, z: 0))
                .opacity(backRotation == 0 ? 1 : 0)

            // Front face (question)
            CardFaceView(card: card, isFront: true)
                .rotation3DEffect(.degrees(frontRotation), axis: (x: 0, y: 1, z: 0))
                .opacity(frontRotation == 0 ? 1 : 0)
                .onTapGesture {
                    if !isShowingAnswer {
                        onReveal()
                    }
                }
        }
        .onChange(of: isShowingAnswer) { _, showing in
            if showing {
                flipToAnswer()
            } else {
                resetToFront()
            }
        }
    }

    private func flipToAnswer() {
        withAnimation(.easeInOut(duration: 0.2)) {
            frontRotation = 90
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                backRotation = 0
            }
        }
    }

    private func resetToFront() {
        withAnimation(.easeInOut(duration: 0.15)) {
            backRotation = -90
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.15)) {
                frontRotation = 0
            }
        }
    }
}

private struct CardFaceView: View {
    let card: VocabularyCard
    let isFront: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
            .overlay {
                if isFront {
                    frontContent
                } else {
                    backContent
                }
            }
            .padding(.horizontal, 24)
    }

    private var frontContent: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(card.word)
                .font(.system(size: 72, weight: .light))
                .minimumScaleFactor(0.4)
                .lineLimit(1)

            Text(card.category)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.accentColor.opacity(0.15)))

            Spacer()

            Text("タップして答えを見る")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 20)
        }
        .padding()
    }

    private var backContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(card.word)
                    .font(.system(size: 36, weight: .medium))
                Spacer()
                Text(card.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.accentColor.opacity(0.15)))
            }

            Text(card.pinyin)
                .font(.title3)
                .foregroundStyle(.secondary)
                .italic()

            Divider()

            Text(card.meaning)
                .font(.title2)
                .fontWeight(.semibold)

            if !card.exampleSentence.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 6) {
                    Text("例文")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Text(card.exampleSentence)
                        .font(.body)
                    Text(card.exampleTranslation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(24)
    }
}
