import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("ダッシュボード", systemImage: "house.fill")
                }
                .tag(0)

            VocabularyListView()
                .tabItem {
                    Label("単語帳", systemImage: "rectangle.stack.fill")
                }
                .tag(1)

            ListeningHubView()
                .tabItem {
                    Label("リスニング", systemImage: "headphones")
                }
                .tag(2)

            PDFTemplateView()
                .tabItem {
                    Label("練習帳", systemImage: "doc.richtext")
                }
                .tag(3)
        }
    }
}
