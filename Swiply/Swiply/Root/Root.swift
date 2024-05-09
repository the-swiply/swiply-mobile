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
    }

    @Dependency(\.forbiddenErrorNotifier) var forbiddenErrorNotifier
    @Dependency(\.appStateManager) var appStateManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                let appState = appStateManager.getState()

                switch appState {
                case .authorization:
                    state.destination = .authorization(.init())

                case .main:
                    state.destination = .main(.init())

                case .profileCreation:
                    state.destination = .profile(.init())
                }
                
                return .run { [forbiddenErrorNotifier] send in
                    forbiddenErrorNotifier.add { [send] in
                        await send(.requestAuthorization)
                    }
                }

            case .destination(.presented(.authorization(.path(.element(id: _, action: .otp(.delegate(.finishAuthorization))))))):
                state.destination = .formCreation(.init())
                return .none

            case .destination(.presented(.formCreation(.path(.element(id: _, action: .work(.continueButtonTapped)))))):
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
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

}
