import ComposableArchitecture
import SwiftUI
import Authorization
import Networking

@Reducer
struct Root {

    @Reducer(state: .equatable)
    enum Destination {
        case authorization(AuthorizationRoot)
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

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                return .run { [forbiddenErrorNotifier] send in
                    forbiddenErrorNotifier.add { [send] in
                        await send(.requestAuthorization)
                    }
                }

            case .appDelegate:
                state.destination = .authorization(.init())
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
