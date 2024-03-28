import ComposableArchitecture
import Authorization
import RandomCoffee

@Reducer
public struct Home {

    @Reducer(state: .equatable)
    public enum Destination {
        case emailConformation(AuthorizationRoot)
        case randomCoffee(RandomCoffeeFeature)
    }

    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    public enum Action {
        case skipWelcome
        case destination(PresentationAction<Destination.Action>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination:
                return .none

            case .skipWelcome:
                state.destination = .emailConformation(.init(path: .init([.emailInput(EmailInput.State())])))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

}
