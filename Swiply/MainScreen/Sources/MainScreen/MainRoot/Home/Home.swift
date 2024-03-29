import ComposableArchitecture
import Authorization
import RandomCoffee

@Reducer
public struct Home {

    @Reducer(state: .equatable)
    public enum Path {
        case emailConformation(EmailInput)
        case otp(OTP)
        case randomCoffee(RandomCoffeeFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
    }

    public enum Action {
        case randomCoffeeTapped
        case emailConfirmationTapped
        case path(StackAction<Path.State, Path.Action>)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .emailConformation(.continueButtonTapped))):
                state.path.append(.otp(.init()))
                return .none

            case .path:
                return .none

            case .emailConfirmationTapped:
                state.path.append(.emailConformation(.init()))
                return .none

            case .randomCoffeeTapped:
                state.path.append(.randomCoffee(.init()))
                return .none

            }
        }
        .forEach(\.path, action: \.path)
    }

}
