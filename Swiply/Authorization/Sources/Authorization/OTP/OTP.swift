import ComposableArchitecture

@Reducer
public struct OTP {

    @ObservableState
    public struct State: Equatable {

        enum RetryButtonState: Equatable {
            case enabled
            case disabled(remainingTime: Int)
        }

        var code: String = ""
        var isFullfilled: Bool = false
        var isIncorrectCodeEntered: Bool = false
        var isRetryButtonDisabled: RetryButtonState = .disabled(remainingTime: 59)

        public init() { }

    }

    public enum Action {

        case binding(Bool)
        case textChanged(String)
        case continueButtonTapped
        case retryButtonTapped
        case timerTick
        case toggleTimer(isOn: Bool)
        case delegate(Delegate)

        @CasePathable
        public enum Delegate {
            case finishAuthorization
        }
        
    }

    private enum CancelID {
      case timer
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.authService) var authService
    @Dependency(\.dataManager) var dataManager

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .run { [state] send in
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            let response = await self.authService.login("", "")
                        }
                        group.addTask {
                            await send(.toggleTimer(isOn: false))
                        }
                    }
                }

            case .retryButtonTapped:
                return .run { send in
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask {
                            let response = await self.authService.sendCode(email: dataManager.getEmail())
                        }
                        group.addTask {
                            await send(.toggleTimer(isOn: false))
                        }
                    }
                }

            case .timerTick:
                switch state.isRetryButtonDisabled {
                case .enabled:
                    state.isRetryButtonDisabled = .disabled(remainingTime: 59)

                case let .disabled(remainingTime):
                    if remainingTime <= 0 {
                        state.isRetryButtonDisabled = .enabled
                        return .send(.toggleTimer(isOn: true))
                    }
                    else {
                        state.isRetryButtonDisabled = .disabled(remainingTime: remainingTime - 1)
                    }
                }

                return .none

            case let .toggleTimer(isOn):
                if isOn {
                    return .cancel(id: CancelID.timer)
                }
                else {
                    return .run { send in
                        await self.startTimer(send: send)
                    }
                    .cancellable(id: CancelID.timer)
                }

            case .textChanged:
                return .none

            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }
    }

    private func startTimer(send: Send<Action>) async {
      for await _ in self.clock.timer(interval: .seconds(1)) {
        await send(.timerTick)
      }
    }

}
