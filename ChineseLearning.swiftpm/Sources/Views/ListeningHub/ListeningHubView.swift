import SwiftUI

struct ListeningHubView: View {
    @State private var viewModel = ListeningHubViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ResourceFilterView(
                    selectedType: $viewModel.selectedType,
                    selectedLevel: $viewModel.selectedLevel,
                    showPinyinOnly: $viewModel.showPinyinOnly
                )

                if viewModel.filteredResources.isEmpty {
                    ContentUnavailableView(
                        "リソースが見つかりません",
                        systemImage: "magnifyingglass",
                        description: Text("フィルターを変更してください")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredResources) { resource in
                                ResourceCardView(resource: resource) {
                                    viewModel.openResource(resource)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("リスニングハブ")
        }
    }
}
