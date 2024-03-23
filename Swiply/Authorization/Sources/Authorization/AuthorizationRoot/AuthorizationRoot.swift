import ComposableArchitecture
import SwiftUI

@Reducer
public struct AuthorizationRoot {

    @Reducer(state: .equatable)
    public enum Path {
        case emailInput(EmailInput)
        case otp(OTP)
    }

    @ObservableState
    public struct State: Equatable {

        var path = StackState<Path.State>()
        var welcome = Welcome.State()

        public init(path: StackState<Path.State> = StackState<Path.State>(),
                    welcome: Welcome.State = Welcome.State()) {
            self.path = path
            self.welcome = welcome
        }

    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case welcome(Welcome.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            Welcome()
        }
        Reduce { state, action in
            switch action {
            case .path(.element(_, .emailInput(.delegate(.receiveSuccessFromServer)))):
                state.path.append(.otp(OTP.State()))
                return .none

            case .path:
                return .none
                
            case let .welcome(action):
                if action == .continueButtonTapped {
                    state.path.append(.emailInput(EmailInput.State()))
                }

                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
