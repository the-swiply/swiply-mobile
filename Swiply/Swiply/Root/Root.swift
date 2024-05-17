import ComposableArchitecture
import SwiftUI
import Authorization
import ProfileCreation
import Networking
import MainScreen
import Chat
import Profile
import SYCore

@Reducer
struct Root {

    @Reducer(state: .equatable)
    enum Destination {
        case authorization(AuthorizationRoot)
        case profileCreation(ProfileCreationRoot)
        case main(MainRoot)
        case chat(ChatRoot)
        case profile(ProfileRoot)
    }

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action {
        case appDelegate(AppDelegateReducer.Action)
        case didChangeScenePhase(ScenePhase)
        case destination(PresentationAction<Destination.Action>)
        case requestAuthorization
        case getUserId
        case findProfile(id: String)
        case createProfile
        case showMain
        case handleforbiddenError
    }

    @Dependency(\.updateTokenMiddleware) var forbiddenErrorNotifier
    @Dependency(\.appStateManager) var appStateManager
    @Dependency(\.profilesService) var rootServiceNetworking
    @Dependency(\.profileManager) var profileManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                return .run { send in
                    await send(.handleforbiddenError)
                    
                    let appState = await appStateManager.getState()

                    switch appState {
                    case .authorization:
                        await send(.requestAuthorization)

                    case .main:
                        await send(.showMain)

                    case .profileCreation:
                        await send(.createProfile)
                   }
                }

            case .handleforbiddenError:
                return .publisher {
                    return forbiddenErrorNotifier.publisher
                        .dropFirst()
                        .receive(on: DispatchQueue.main)
                        .map { Action.requestAuthorization }
                }

            case .destination(.presented(.authorization(.path(.element(id: _, action: .otp(.delegate(.finishAuthorization))))))):
                return .run { send in
                    await send(.getUserId)
                }

            case .destination(.presented(.profileCreation(.path(.element(id: _, action: .work(let .delegate(.finishProfile(user)))))))):
                return .run { send in
                        let response = await self.rootServiceNetworking.createProfile(profile: user)
                    
                        switch response {
                        case let .success(user):
                            appStateManager.setProfileCreationComplete()
                            profileManager.setUserId(id: user.id)
                            await send(.findProfile(id: user.id))
                        case .failure:
                            break
                        }
                }
                appStateManager.setProfileCreationComplete()
            case .appDelegate:
                return .none

            case .requestAuthorization:
                state.destination = .authorization(AuthorizationRoot.State())
                return .none

            case .didChangeScenePhase:
                return .none

            case .destination:
                return .none

            case .createProfile:
                state.destination = .profileCreation(.init())
                return .none

            case .showMain:
                state.destination = .main(.init(selectedTab: .profile))
                return .none

            case .getUserId:
                let userId = profileManager.getUserId()
                if userId.isEmpty {
                    return .run { send in
                        let response = await self.rootServiceNetworking.whoAmI()
                        switch response {
                        case let .success(userId):
                            profileManager.setUserId(id: userId.id)
                            await send(.findProfile(id: userId.id))
                        case .failure:
                            break
                        }
                    }
                } else {
                    return .run { send in
                        await send(.findProfile(id: userId))
                    }
                }
                
            case let .findProfile(id):
                return .run { send in
                    let responseProfile = await self.rootServiceNetworking.getProfile(id: id)
                    switch responseProfile {
                    case let .success(profile):
                        profileManager.setProfileInfo(profile)
                        await send(.showMain)
                    case .failure:
                        await send(.createProfile)
                    }
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

}

