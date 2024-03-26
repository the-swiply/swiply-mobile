import ComposableArchitecture

@Reducer
public struct Recommendations {

    @ObservableState
    public struct State: Equatable {

        public init() { }

    }

    public enum Action: Equatable {
        case continueButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .none
            }
        }
    }

}
