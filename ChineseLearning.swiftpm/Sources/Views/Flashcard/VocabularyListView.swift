import SwiftUI
import SwiftData

struct VocabularyListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \VocabularyCard.hskLevel) private var allCards: [VocabularyCard]

    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var navigateToStudy = false

    private var categories: [String] {
        Array(Set(allCards.map(\.category))).sorted()
    }

    private var filteredCards: [VocabularyCard] {
        allCards.filter { card in
            let matchesSearch = searchText.isEmpty ||
                card.word.localizedCaseInsensitiveContains(searchText) ||
                card.pinyin.localizedCaseInsensitiveContains(searchText) ||
                card.meaning.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || card.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "すべて", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(categories, id: \.self) { cat in
                            FilterChip(title: cat, isSelected: selectedCategory == cat) {
                                selectedCategory = (selectedCategory == cat) ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                List(filteredCards) { card in
                    VocabRow(card: card)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "単語・ピンイン・意味で検索")
            }
            .navigationTitle("単語帳")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: FlashcardStudyView()) {
                        Label("学習開始", systemImage: "play.fill")
                    }
                }
            }
        }
    }
}

private struct VocabRow: View {
    let card: VocabularyCard

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(card.word)
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(card.pinyin)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                }
                Text(card.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if card.isLearned {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
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
