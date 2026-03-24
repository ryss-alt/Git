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
        let defaults = UserDefaults.standard
        let seedKey = "seedDataLoaded_v1"
        guard !defaults.bool(forKey: seedKey) else { return }

        let files = ["hsk3_4", "hsk1_2", "business"]
        for filename in files {
            loadFile(named: filename, context: context)
        }

        defaults.set(true, forKey: seedKey)
    }

    private static func loadFile(named filename: String, context: ModelContext) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json", subdirectory: "VocabularyData"),
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

    /// Resets seed data (for testing or re-seeding after update).
    static func reset() {
        UserDefaults.standard.removeObject(forKey: "seedDataLoaded_v1")
    }
}
