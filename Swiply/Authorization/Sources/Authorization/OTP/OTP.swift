import ComposableArchitecture

@Reducer
public struct OTP {

    public struct State: Equatable {

        enum RequestState: Equatable {
            case sent(remainingTime: Int)
            case notSent
        }

        let isFullfilled: Bool = false
        let isIncorrectCodeEntered: Bool = false
        let requestState: RequestState

        init(remainingTime: Int?) {
            if let remainingTime {
                self.requestState = .sent(remainingTime: remainingTime)
            }
            else {
                self.requestState = .notSent
            }
        }

    }

    public enum Action {

        case continueButtonTapped
        case retryButtonTapped
        case delegate(Delegate)

        @CasePathable
        public enum Delegate {
            case finishAuthorization
        }
        
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .none

            case .retryButtonTapped:
                return .none

            case .delegate:
                return .none
            }
        }
    }

}
