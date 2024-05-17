import ComposableArchitecture

@Reducer
public struct EventsFeature {

    @ObservableState
    public struct State: Equatable {


        public init() {}
    }
    public enum Action: Equatable {
        case onAppear
    }

    @Dependency(\.eventsNetworking) var eventsNetworking

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await eventsNetworking.getEvents()
                }
            }
        }
    }

    public init() {}

}
