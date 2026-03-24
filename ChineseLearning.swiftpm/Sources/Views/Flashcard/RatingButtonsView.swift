import SwiftUI

struct RatingButtonsView: View {
    let onGrade: (SRSEngine.Quality) -> Void

    var body: some View {
        HStack(spacing: 10) {
            ForEach(SRSEngine.Quality.allCases, id: \.rawValue) { quality in
                RatingButton(quality: quality) {
                    onGrade(quality)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct RatingButton: View {
    let quality: SRSEngine.Quality
    let action: () -> Void

    private var buttonColor: Color {
        switch quality {
        case .again: return .red
        case .hard:  return .orange
        case .good:  return .green
        case .easy:  return .blue
        }
    }

    var body: some View {
        Button(action: action) {
            Text(quality.displayName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(buttonColor.opacity(0.15))
                .foregroundStyle(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(buttonColor.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
