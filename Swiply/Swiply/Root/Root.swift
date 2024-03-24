import ComposableArchitecture
import SwiftUI
import Authorization
import FormCreation
import Networking
import MainScreen

@Reducer
struct Root {

    @Reducer(state: .equatable)
    enum Destination {
        case authorization(AuthorizationRoot)
        case formCreation(FormCreationRoot)
        case main(MainRoot)
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
                state.destination = .main(.init())
                
                return .run { [forbiddenErrorNotifier] send in
                    forbiddenErrorNotifier.add { [send] in
                        await send(.requestAuthorization)
                    }
                }

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
