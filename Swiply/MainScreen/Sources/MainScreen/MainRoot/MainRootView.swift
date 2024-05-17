import SwiftUI
import ComposableArchitecture
import Networking
import Recommendations
import Likes
import Profile
import Chat

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

            RecommendationsView(store: store.scope(state: \.recommendations, action: \.recommendations))
                .tabItem {
                    Image(.recommendationsTab)
//                    Text("Swiply")
                }.tag(MainRoot.Tab.recommendations)

            ChatRootView(store: store.scope(state: \.chat, action: \.chat))
                .tabItem {
                    Image(.chatTab)
//                    Text("Чат")
                }.tag(MainRoot.Tab.chat)

            ProfileRootView(store: store.scope(state: \.profile, action: \.profile))
                .tabItem {
                    Image(.profileTab)
//                    Text("Профиль")
                }.tag(MainRoot.Tab.profile)
        })
        .tint(.pink)
    }

}
