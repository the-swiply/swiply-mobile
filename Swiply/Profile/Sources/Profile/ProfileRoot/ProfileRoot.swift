import ComposableArchitecture
import SwiftUI
import Authorization
import SYCore
import ProfilesService

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
        case showError
        case showEdit(user: Person, interest: [Interest])
    }
    
    public init() {}
    
    @Dependency(\.profileManager) var profileManager
    @Dependency(\.profilesService) var profileNetworking
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        Reduce { state, action in
            switch action {
            case let .profile(action):
                switch action {
                case let .showEdit(user):
                    return .run { send in
                        let response = await profileNetworking.getInterestsLists()
                        switch response {
                        case let .success(list):
                            await send(.showEdit(user: user, interest: list.interests))
                        case .failure:
                            await send(.showError)
                        }
                    }
              
                case .onSettingsTap:
                    state.path.append(.settings(SettingsFeature.State(
                        match: profileManager.isMatchOn(),
                        messages: profileManager.isMessageOn(),
                        likes: profileManager.isLikeOn(),
                        meeting: profileManager.isMeetingOn()
                    )))
                default:
                    break
                }
                return .none
            case .path(.element(_, let .edit(.saveChanges(person)))):
                let profile = person.toProfile(state.profile.user)
                return .run { [state] send in
                    let response = await profileNetworking.updateProfile(profile: profile)
                    let responsePhotos = await profileNetworking.updatePhoto(old: state.profile.user, new: profile)
                    switch (response, responsePhotos) {
                    case (.success, .success):
                        state.profile.user = person.toProfile(state.profile.user)
                    default:
                        await send(.showError)
                    }
                }
                
            case .path(.element(_, .settings(.exitButtonTapped))):
                state.path.append(.emailConformation(AuthorizationRoot.State()))
                return .none
            case .path:
                return .none
            case .showError:
                state.profile.showError = true
                return .none
            case let .showEdit(user, interest):
                state.path.append(.edit(EditFeature.State(info: user, interests: interest)))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
