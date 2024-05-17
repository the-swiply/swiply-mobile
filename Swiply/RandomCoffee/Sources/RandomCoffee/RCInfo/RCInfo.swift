import SwiftUI
import ComposableArchitecture
import SYVisualKit
import SYCore

@Reducer
public struct RCInfo {
    
    @ObservableState
    public struct State: Equatable {
         var showError = false
        var error: RandomCoffeeError = .none
        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
        case showRandomCoffee
        case showError(RandomCoffeeError)
    }
    
    @Shared(.inMemory("Person")) var user = Profile()
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .run { send in
                    if user.corporateMail.isEmpty {
                        await send(.showError(.noOrganization))
                    } else {
                        await send(.showRandomCoffee)
                    }
                }
            case .binding:
                return .none
            case .showRandomCoffee:
                return .none
            case let .showError(error):
                state.error = error
                state.showError = true
                return .none
            }
        }
    }
    
    public init() {}

}
