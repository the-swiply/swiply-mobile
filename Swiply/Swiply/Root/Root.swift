import ComposableArchitecture
import SwiftUI
import Authorization
import FormCreation
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
        case formCreation(FormCreationRoot)
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
        case findProfile
        case createProfile
        case showMain
    }

    @Dependency(\.updateTokenMiddleware) var forbiddenErrorNotifier
    @Dependency(\.appStateManager) var appStateManager
    @Dependency(\.rootServiceNetworking) var rootServiceNetworking
    @Dependency(\.profileManager) var profileManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                let appState = appStateManager.getState()

                switch appState {
                case .authorization:
                    state.destination = .authorization(.init())

                case .main, .profileCreation:
                    state.destination = .main(.init())

//                case .profileCreation:
//                    state.destination = .formCreation(.init())
                }
                
                return .run { [forbiddenErrorNotifier] send in
                    forbiddenErrorNotifier.add { [send] in
                        await send(.requestAuthorization)
                    }
                }

            case .destination(.presented(.authorization(.path(.element(id: _, action: .otp(.delegate(.finishAuthorization))))))):
                appStateManager.setAuthComplete()
//                state.destination = .formCreation(.init())
                return .run { send in
                    await send(.findProfile)
                }

            case .destination(.presented(.formCreation(.path(.element(id: _, action: .work(.delegate(.finishProfile))))))):
                appStateManager.setProfileCreationComplete()
                state.destination = .main(.init(selectedTab: .profile))
                
                return .none

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
                state.destination = .formCreation(.init())
                return .none
            case .showMain:
                state.destination = .main(.init(selectedTab: .profile))
                return .none
            case .findProfile:
                return .run { send in
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            let response = await self.rootServiceNetworking.whoAmI()

                            switch response {
                            case let .success(userId):
                                //TODO:- сохранение профиля id и запрос данных
                                profileManager.setUserId(id: userId.id)
                                await send(.showMain)
                            case .failure:
                                await send(.createProfile)
                            }
                        }
                    }
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

}
