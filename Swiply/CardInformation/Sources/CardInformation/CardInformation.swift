import ComposableArchitecture
import StoreKit
import OSLog
import SYCore

@Reducer
public struct CardInformation {

    @ObservableState
    public struct State: Equatable {
        public var profile = Profile()

        public init(profile: Profile) {
            self.profile = profile
        }
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
