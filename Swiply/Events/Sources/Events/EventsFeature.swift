import ComposableArchitecture

@Reducer
public struct EventsFeature {

    @ObservableState
    public struct State: Equatable {


        public init() {}
    }
    public enum Action: Equatable {

    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }

    public init() {}

}
