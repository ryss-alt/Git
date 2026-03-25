import Foundation
import SwiftData

struct SeedDataLoader {

    private struct CardJSON: Codable {
        let word: String
        let pinyin: String
        let meaning: String
        let example: String
        let example_translation: String
        let hsk_level: Int
    }

    private struct SeedFile: Codable {
        let version: Int
        let category: String
        let cards: [CardJSON]
    }

    static func loadIfNeeded(context: ModelContext) {
        // Use DB count as source of truth — UserDefaults can be stale
        let count = (try? context.fetchCount(FetchDescriptor<VocabularyCard>())) ?? 0
        guard count == 0 else { return }

        let files = ["hsk1_2", "hsk3_4", "business"]
        for filename in files {
            loadFile(named: filename, context: context)
        }

        try? context.save()
    }

    private static func loadFile(named filename: String, context: ModelContext) {
        // Try with subdirectory first, then flat (Swift Playgrounds 4 bundle layout varies)
        let url = Bundle.main.url(forResource: filename, withExtension: "json", subdirectory: "VocabularyData")
            ?? Bundle.main.url(forResource: filename, withExtension: "json")

        guard let url,
              let data = try? Data(contentsOf: url),
              let seed = try? JSONDecoder().decode(SeedFile.self, from: data)
        else {
            print("SeedDataLoader: Could not load \(filename).json")
            return
        }

        for card in seed.cards {
            let vocabCard = VocabularyCard(
                word: card.word,
                pinyin: card.pinyin,
                meaning: card.meaning,
                exampleSentence: card.example,
                exampleTranslation: card.example_translation,
                category: seed.category,
                hskLevel: card.hsk_level
            )
            context.insert(vocabCard)
        }

        print("SeedDataLoader: Loaded \(seed.cards.count) cards from \(filename).json")
    }
}
