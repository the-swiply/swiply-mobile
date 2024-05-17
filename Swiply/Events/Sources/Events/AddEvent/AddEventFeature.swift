import ComposableArchitecture

@Reducer
public struct AddEventFeature {

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    public enum Action: Equatable {
        case tapped
    }

    @Dependency(\.eventsNetworking) var eventsNetworking

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }

    public init() {}

}
