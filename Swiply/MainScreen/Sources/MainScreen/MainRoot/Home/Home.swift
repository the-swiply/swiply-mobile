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
        case downloadRandomCoffee
        case showRandomCoffee(CreateMeeting)
    }

    public init() { }
    
    @Dependency(\.coffeeManager) var coffeeManager
    @Dependency(\.coffeeService) var coffeeService
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .path(.element(id: _, action: .randomCoffeeInfo(.showRandomCoffee))):
                coffeeManager.didShowCoffee()
                return .run { send in
//                    await send(.downloadRandomCoffee)
                    await send(.showRandomCoffee(CreateMeeting()))
                }
                
            case .path(.element(id: _, action: .emailConformation(.delegate(.receiveSuccessFromServer)))):
                state.path.append(.otp(.init()))
                return .none

            case .path:
                return .none

            case .emailConfirmationTapped:
                state.path.append(.emailConformation(.init()))
                return .none

            case .randomCoffeeTapped:
                
//                if !coffeeManager.shouldShow() {
                  
                    state.path.append(.randomCoffeeInfo(.init()))
//                } else {
//                    return .run { send in
//                        await send(.downloadRandomCoffee)
//                    }
//                }
                return .none

            case .eventsTapped:
                state.path.append(.events(.init()))
                return .none

            case .downloadRandomCoffee:
                return .run { send in
                    let response = await coffeeService.getMeeting()
                    
                    switch response {
                    case let .success(coffee):
                        await send(.showRandomCoffee(coffee.toCreateMeeting()))
                    case .failure:
                        await send(.showRandomCoffee(CreateMeeting()))
                    }
                }
                
            case let .showRandomCoffee(coffee):
                state.path.append(.randomCoffee(RandomCoffeeFeature.State(meeting: coffee)))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
