import SwiftUI
import ComposableArchitecture
import Networking
import Recommendations
import Likes

public struct MainRootView: View {

    @Bindable var store: StoreOf<MainRoot>

    public init(store: StoreOf<MainRoot>) {
        self.store = store
    }

    // MARK: - View

    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected),
                content:  {
            HomeView(store: store.scope(state: \.features, action: \.features))
                .tabItem {
                    Image(.homeTab)
//                    Text("Активности")
                }.tag(MainRoot.Tab.features)

            LikesView()
                .tabItem {
                    Image(.likesTab)
//                    Text("Лайки")
                }.tag(MainRoot.Tab.likes)

            RecommendationsView()
                .tabItem {
                    Image(.recommendationsTab)
//                    Text("Swiply")
                }.tag(MainRoot.Tab.recommendations)

            Text("Tab Content 2")
                .tabItem {
                    Image(.chatTab)
//                    Text("Чат")
                }.tag(MainRoot.Tab.chat)

            Text("Tab Content 1")
                .tabItem {
                    Image(.profileTab)
//                    Text("Профиль")
                }.tag(MainRoot.Tab.profile)
        })
        .tint(.pink)
    }

}
