import SwiftUI
import SwiftData

struct PDFTemplateView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \VocabularyCard.hskLevel) private var allCards: [VocabularyCard]

    @State private var selectedCardIDs: Set<UUID> = []
    @State private var isGenerating = false
    @State private var generatedPDFData: Data? = nil
    @State private var showShareSheet = false
    @State private var filterCategory: String? = nil

    private var categories: [String] {
        Array(Set(allCards.map(\.category))).sorted()
    }

    private var filteredCards: [VocabularyCard] {
        guard let cat = filterCategory else { return Array(allCards) }
        return allCards.filter { $0.category == cat }
    }

    private var selectedCards: [VocabularyCard] {
        allCards.filter { selectedCardIDs.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "すべて", isSelected: filterCategory == nil) {
                            filterCategory = nil
                        }
                        ForEach(categories, id: \.self) { cat in
                            FilterChip(title: cat, isSelected: filterCategory == cat) {
                                filterCategory = (filterCategory == cat) ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                Divider()

                List(filteredCards) { card in
                    HStack {
                        Image(systemName: selectedCardIDs.contains(card.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(selectedCardIDs.contains(card.id) ? Color.accentColor : .secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(card.word).font(.headline)
                                Text(card.pinyin).font(.subheadline).foregroundStyle(.secondary).italic()
                            }
                            Text(card.meaning).font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedCardIDs.contains(card.id) {
                            selectedCardIDs.remove(card.id)
                        } else {
                            selectedCardIDs.insert(card.id)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("PDF練習帳")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task { await generatePDF() }
                    } label: {
                        if isGenerating {
                            ProgressView().tint(.white)
                        } else {
                            Label("PDF生成 (\(selectedCardIDs.count))", systemImage: "doc.richtext")
                        }
                    }
                    .disabled(selectedCardIDs.isEmpty || isGenerating)
                }

                ToolbarItem(placement: .secondaryAction) {
                    Button("すべて選択") {
                        selectedCardIDs = Set(filteredCards.map(\.id))
                    }
                }

                ToolbarItem(placement: .secondaryAction) {
                    Button("選択解除") {
                        selectedCardIDs.removeAll()
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let data = generatedPDFData {
                    let tempURL = writeTempPDF(data: data)
                    ShareSheet(items: [tempURL as Any].compactMap { $0 })
                }
            }
        }
    }

    private func generatePDF() async {
        isGenerating = true
        let cards = selectedCards
        let generator = PDFGenerator()
        let data = await generator.generate(cards: cards)
        await MainActor.run {
            generatedPDFData = data
            isGenerating = false
            if data != nil {
                showShareSheet = true
            }
        }
    }

    private func writeTempPDF(data: Data) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let url = tempDir.appendingPathComponent("漢路_練習帳.pdf")
        try? data.write(to: url)
        return url
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
