import ComposableArchitecture
import SwiftUI
import Profile
import Chat

@Reducer
public struct MainRoot {

    public enum Tab {
        case features
        case likes
        case recommendations
        case chat
        case profile
    }

    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab
        var features = Home.State()
        var profile = ProfileRoot.State()
        var chat = ChatRoot.State()

        public init(selectedTab: Tab = Tab.recommendations) {
            self.selectedTab = selectedTab
        }
    }

    public enum Action {
        case tabSelected(Tab)
        case features(Home.Action)
        case profile(ProfileRoot.Action)
        case chat(ChatRoot.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            case .features:
                return .none
            case .profile:
                return .none
            case .chat:
                return .none
            }
        }
        Scope(state: \.features, action: \.features) {
            Home()
        }
        
        Scope(state: \.profile, action: \.profile) {
            ProfileRoot()
        }
        
        Scope(state: \.chat, action: \.chat) {
            ChatRoot()
        }
    }

}

