import ComposableArchitecture
import SwiftUI
import Profile
import Chat
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
            case .loadProfile:
                return .run { send in
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            let response = await self.profilesService.getProfile(
                                id: profileManager.getUserId()
                            )

                            switch response {
                            case let .success(user):
                                //TODO:- сохранение профиля id и запрос данных
//                                state.user = .init(user)
                                
                                profileManager.setProfileInfo(.init(user))
//                                await send(.showMain)
                            case .failure:
                                break
//                                await send(.createProfile)
                            }
                        }
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
    }

}

