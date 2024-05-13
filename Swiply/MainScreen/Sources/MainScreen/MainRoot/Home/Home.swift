import ComposableArchitecture
import Authorization
import RandomCoffee
import Events

@Reducer
public struct Home {

    @Reducer(state: .equatable)
    public enum Path {
        case emailConformation(EmailInput)
        case otp(OTP)
        case randomCoffeeInfo(RCInfo)
        case randomCoffee(RandomCoffeeFeature)
        case events(EventsFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
    }

    public enum Action {
        case randomCoffeeTapped
        case emailConfirmationTapped
        case eventsTapped
        case path(StackAction<Path.State, Path.Action>)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .randomCoffeeInfo(.continueButtonTapped))):
                state.path.append(.randomCoffee(.init()))
//                state.path.removeFirst()
                return .none
                
            case .path(.element(id: _, action: .emailConformation(.delegate(.receiveSuccessFromServer)))):
                state.path.append(.otp(.init()))
                return .none

            case .path:
                return .none

            case .emailConfirmationTapped:
                state.path.append(.emailConformation(.init()))
                return .none

            case .randomCoffeeTapped:
                state.path.append(.randomCoffeeInfo(.init()))
                return .none

            case .eventsTapped:
                state.path.append(.events(.init()))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
