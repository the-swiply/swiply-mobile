import ComposableArchitecture

@Reducer
public struct EventsFeature {

    @Reducer(state: .equatable)
    public enum Path {
        case eventCreation(AddEventFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var events: [Event] = []
        var likes: [Event] = []
        var my: [Event] = []
        var all: [Event] = []
        var path = StackState<Path.State>()
        public init() {}
    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case onAppear
        case updateEvents([Event])
        case updateMyEvents([Event])
        case updateLikedEvents([Event])
        case openEventCreation
    }

    @Dependency(\.eventsNetworking) var eventsNetworking

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let response = await eventsNetworking.getEvents()

                    switch response {
                    case let .success(model):
                        let events = model.events.map { $0.toEvent }
                        await send(.updateEvents(events))

                    case .failure:
                        break
                    }

                    let myResponse = await eventsNetworking.myEvents()

                    switch myResponse {
                    case let .success(model):
                        let events = model.events.map { $0.toEvent }
                        await send(.updateEvents(events))

                    case .failure:
                        break
                    }

                    let likedResponse = await eventsNetworking.myEvents()

                    switch myResponse {
                    case let .success(model):
                        let events = model.events.map { $0.toEvent }
                        await send(.updateEvents(events))

                    case .failure:
                        break
                    }
                }

            case let .updateEvents(events):
                state.events = events
                return .none

            case let .updateMyEvents(events):
                state.my = events
                return .none

            case let .updateLikedEvents(events):
                state.likes = events
                return .none

            case .path:
                return .none

            case .openEventCreation:
                state.path.append(.eventCreation(.init()))
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

    public init() {}

}
