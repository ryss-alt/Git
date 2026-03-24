import SwiftUI

struct ResourceFilterView: View {
    @Binding var selectedType: ResourceType?
    @Binding var selectedLevel: HSKLevel?
    @Binding var showPinyinOnly: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // Type filters
                    FilterChip(title: "すべて", isSelected: selectedType == nil) {
                        selectedType = nil
                    }
                    ForEach(ResourceType.allCases, id: \.rawValue) { type in
                        FilterChip(title: type.displayName, isSelected: selectedType == type) {
                            selectedType = (selectedType == type) ? nil : type
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "全レベル", isSelected: selectedLevel == nil) {
                        selectedLevel = nil
                    }
                    ForEach(HSKLevel.allCases, id: \.rawValue) { level in
                        FilterChip(title: level.displayName, isSelected: selectedLevel == level) {
                            selectedLevel = (selectedLevel == level) ? nil : level
                        }
                    }
                    FilterChip(title: "ピンインあり", isSelected: showPinyinOnly) {
                        showPinyinOnly.toggle()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            Divider()
        }
        .background(Color(.systemBackground))
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
