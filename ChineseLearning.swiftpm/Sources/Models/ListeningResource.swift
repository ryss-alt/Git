import Foundation

enum ResourceType: String, Codable, CaseIterable {
    case youtube = "youtube"
    case podcast = "podcast"
    case website = "website"

    var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .podcast: return "Podcast"
        case .website: return "Web"
        }
    }

    var systemImage: String {
        switch self {
        case .youtube: return "play.rectangle.fill"
        case .podcast: return "mic.fill"
        case .website: return "globe"
        }
    }
}

enum HSKLevel: String, Codable, CaseIterable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"

    var displayName: String {
        switch self {
        case .beginner: return "初級"
        case .intermediate: return "中級"
        case .advanced: return "上級"
        }
    }
}

struct ListeningResource: Codable, Identifiable {
    let id: String
    let title: String
    let originalTitle: String
    let description: String
    let resourceType: ResourceType
    let level: HSKLevel
    let hasJapaneseSubtitles: Bool
    let hasPinyin: Bool
    let url: String
    let deepLinkURL: String?
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case id, title
        case originalTitle = "original_title"
        case description
        case resourceType = "resource_type"
        case level
        case hasJapaneseSubtitles = "has_japanese_subtitles"
        case hasPinyin = "has_pinyin"
        case url
        case deepLinkURL = "deep_link_url"
        case tags
    }
}
