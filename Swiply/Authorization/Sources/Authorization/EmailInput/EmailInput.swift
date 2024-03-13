import ComposableArchitecture

@Reducer
public struct EmailInput {

    @ObservableState
    public struct State: Equatable {

        var text: String = ""
        var isContinueButtonDisabled = true
        var isRequestSent: Bool = false

        public init(text: String = "", isContinueButtonDisabled: Bool = true, isRequestSent: Bool = false) {
            self.text = text
            self.isContinueButtonDisabled = isContinueButtonDisabled
            self.isRequestSent = isRequestSent
        }
        
    }

    public enum Action {
        case textChanged(String)
        case continueButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .none

            case .textChanged(let text):
                state.isContinueButtonDisabled = text.isEmpty

                return .none
            }
        }
    }

}
