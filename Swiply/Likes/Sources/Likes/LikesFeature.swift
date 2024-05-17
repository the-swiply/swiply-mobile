import ComposableArchitecture
import StoreKit
import OSLog

@Reducer
public struct LikesFeature {

    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("hasSubscription")) var hasSubscription = false

        public init() { }
    }

    public enum Action: Equatable {
        case buyTapped
    }

    public init() { }


    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .buyTapped:
                return .none
            }
        }
    }

}
