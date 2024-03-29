import ComposableArchitecture
import SwiftUI
import Authorization

@Reducer
public struct ProfileRoot {
    
    @Reducer(state: .equatable)
    public enum Path {
        case edit(EditFeature)
        case settings(SettingsFeature)
        case emailConformation(AuthorizationRoot)
    }
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
        public var profile = ProfileFeature.State()
        
        public init(path: StackState<Path.State> = StackState<Path.State>(), profile: ProfileFeature.State = ProfileFeature.State()) {
            self.path = path
            self.profile = profile
        }
    }
    
    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case profile(ProfileFeature.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        Reduce { state, action in
            switch action {
            case let .profile(action):
                switch action {
                case let .showEdit(user):
                    state.path.append(.edit(EditFeature.State(info: user)))
                case .onSettingsTap:
                    state.path.append(.settings(SettingsFeature.State()))
                default:
                    break
                }
                return .none
            case .path(.element(_, let .edit(.saveChanges(person)))):
                state.profile.user = person
                return .none
                
            case .path(.element(_, .settings(.exitButtonTapped))):
                state.path.append(.emailConformation(AuthorizationRoot.State()))
                return .none
            case .path:
                return .none
                
            }
//            switch action {
//            case let .chats(action):
//                switch action {
//                case let .showChat(chat):
//                    state.path.append(.personalChat(EditFeature.State()))
//                default:
//                    break
//                }
//                
//                return .none
//            case .path(.element(_, let .personalChat(.update(chat)))):
//                
//                if let index = state.chats.chat.firstIndex(where: { $0.id == chat.id }) {
//                    state.chats.chat[index] = chat
//                } else {
//                    state.chats.chat.append(chat)
//                }
//                return .none
//            case .path:
//                return .none
//            }
        }
        .forEach(\.path, action: \.path)
    }
}
