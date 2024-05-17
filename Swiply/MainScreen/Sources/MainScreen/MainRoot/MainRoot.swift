import ComposableArchitecture
import SwiftUI
import Profile
import Chat
import Recommendations
import ProfilesService
import OSLog

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
        var recommendations = Recommendations.State()
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
        case recommendations(Recommendations.Action)
        case loadProfile
    }

    public init() {}
    
    @Dependency(\.profilesService) var profilesService
    @Dependency(\.profileManager) var profileManager

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .run { send in
                    await send(.loadProfile)
                }

            case .features:
                return .none

            case .profile:
                return .none

            case .chat:
                return .none

            case .recommendations:
                return .none

            case .loadProfile:
                return .run { send in
                    let response = await self.profilesService.getProfile(
                        id: profileManager.getUserId()
                    )

                    switch response {
                    case let .success(user):
                        profileManager.setProfileInfo(user)
                    case .failure:
                        break
                    }
                }
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
        Scope(state: \.recommendations, action: \.recommendations) {
            Recommendations()
        }
    }

}

