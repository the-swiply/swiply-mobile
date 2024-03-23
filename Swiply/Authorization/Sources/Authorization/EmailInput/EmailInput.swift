import ComposableArchitecture

@Reducer
public struct EmailInput {

    @ObservableState
    public struct State: Equatable {

        var text: String
        var isContinueButtonDisabled: Bool
        var childState: ChildState = .init()

        public struct ChildState: Equatable {
            var remainingTime: Int?

            public init(remainingTime: Int? = nil) {
                self.remainingTime = remainingTime
            }
        }

        public init(text: String = "", isContinueButtonDisabled: Bool = true, childState: ChildState = .init()) {
            self.text = text
            self.isContinueButtonDisabled = isContinueButtonDisabled
            self.childState = childState
        }

    }

    public enum Action {
        case textChanged(String)
        case continueButtonTapped
        case receiveFailureFromServer
        case delegate(Delegate)

        @CasePathable
        public enum Delegate {
            case receiveSuccessFromServer
        }
    }

    @Dependency(\.authService.sendCode) var sendCode
    @Dependency(\.dataManager) var dataManager

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                state.isContinueButtonDisabled = true
                dataManager.setEmail(state.text)

                return .run { [state] send in
                    let result = await sendCode(state.text)

                    switch result {
                    case .success:
                        dataManager.setEmail(state.text)
                        await send(.delegate(.receiveSuccessFromServer))

                    case .failure:
                        await send(.receiveFailureFromServer)
                    }
                }

            case .receiveFailureFromServer:
                return .none

            case .textChanged(let text):
                state.isContinueButtonDisabled = text.isEmpty
                state.text = text
                return .none

            case .delegate:
                return .none
            }
        }
    }

}
