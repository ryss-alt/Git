import SwiftUI

struct ResourceCardView: View {
    let resource: ListeningResource
    let onTap: () -> Void

    private var levelColor: Color {
        switch resource.level {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }

    private var typeColor: Color {
        switch resource.resourceType {
        case .youtube: return .red
        case .podcast: return .purple
        case .website: return .blue
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Type badge
                    Label(resource.resourceType.displayName, systemImage: resource.resourceType.systemImage)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(typeColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(typeColor.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()

                    // Level badge
                    Text(resource.level.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(levelColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(levelColor.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text(resource.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Text(resource.originalTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(resource.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                // Tags + badges
                HStack(spacing: 8) {
                    if resource.hasPinyin {
                        TagBadge(text: "ピンインあり", color: .blue)
                    }
                    if resource.hasJapaneseSubtitles {
                        TagBadge(text: "日本語字幕", color: .green)
                    }
                    ForEach(resource.tags.prefix(2), id: \.self) { tag in
                        TagBadge(text: tag, color: .gray)
                    }
                }
                .padding(.top, 2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

private struct TagBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}
