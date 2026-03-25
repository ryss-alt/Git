import Foundation
import SwiftUI
import UIKit

@Observable
final class ListeningHubViewModel {
    private(set) var allResources: [ListeningResource] = []
    var selectedType: ResourceType? = nil
    var selectedLevel: HSKLevel? = nil
    var showPinyinOnly: Bool = false

    var filteredResources: [ListeningResource] {
        allResources.filter { resource in
            let matchesType = selectedType == nil || resource.resourceType == selectedType
            let matchesLevel = selectedLevel == nil || resource.level == selectedLevel
            let matchesPinyin = !showPinyinOnly || resource.hasPinyin
            return matchesType && matchesLevel && matchesPinyin
        }
    }

    init() {
        loadResources()
    }

    private func loadResources() {
        guard let url = Bundle.main.url(forResource: "resources", withExtension: "json", subdirectory: "ListeningResources"),
              let data = try? Data(contentsOf: url)
        else {
            print("ListeningHubViewModel: Could not load resources.json")
            return
        }

        struct ResourcesFile: Codable {
            let version: Int
            let resources: [ListeningResource]
        }

        if let file = try? JSONDecoder().decode(ResourcesFile.self, from: data) {
            allResources = file.resources
        }
    }

    func openResource(_ resource: ListeningResource) {
        if let deepURL = resource.deepLinkURL.flatMap({ URL(string: $0) }),
           UIApplication.shared.canOpenURL(deepURL) {
            UIApplication.shared.open(deepURL)
        } else if let fallbackURL = URL(string: resource.url) {
            UIApplication.shared.open(fallbackURL)
        }
    }
}
