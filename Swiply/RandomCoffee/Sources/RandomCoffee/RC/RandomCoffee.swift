import ComposableArchitecture
import Foundation
import SYCore

@Reducer
public struct RandomCoffeeFeature {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("Person")) var user = Profile()
        var meeting: CreateMeeting
        var time: TimeInterval = 10000
        var timeString: String = ""
        var isON = false
        var isButtonDisabled = true
        var organization = ""
        var showError = false
        var error: RandomCoffeeError = .none
        
        public init(meeting: CreateMeeting) {
            self.meeting = meeting
            organization = user.corporateMail.first?.name ?? ""
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
    @Dependency(\.coffeeService) var coffeeService
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
        case timerTick
        case startTimer
        case dismiss
        case showError(RandomCoffeeError)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .run { _ in
                    await self.dismiss()
                }
            case .binding:
                state.isButtonDisabled = false
                return .none

            case .continueButtonTapped:
                state.isON = true
                if state.meeting.meetingId.isEmpty {
                    state.isON = true
                    return .run { [state] send in
                        let response = await coffeeService.createMeeting(info: state.meeting)
                        
                        switch response {
                        case .success:
                            await send(.startTimer)
                        case .failure:
                            await send(.showError(.networkError))
                        }
                    }
                } else {
                    return .run { [state] send in
                        let response = await coffeeService.updateMeeting(id: state.meeting.meetingId, info: state.meeting)
                        
                        switch response {
                        case .success:
                            await send(.showError(.none))
                        case .failure:
                            await send(.showError(.networkError))
                        }
                    }
                }
            case .startTimer:
                state.isON = true
                return .run { send in
                    await self.startTimer(send: send)
                }

            case .timerTick:
                state.time -= 1
                state.timeString = state.time.format()
                return .none
                
            case let .showError(error):
                state.error = error
                state.showError = true
                return .none
            }
        }
    }
    
    public init() {}

    private func startTimer(send: Send<Action>) async {
      for await _ in self.clock.timer(interval: .seconds(1)) {
        await send(.timerTick)
      }
    }
}
