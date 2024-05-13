import SwiftUI
import ComposableArchitecture
import SYVisualKit

@Reducer
public struct RandomCoffeeFeature {
    
    @ObservableState
    public struct State: Equatable {
        var selectedDate = Date()
        var startTime = Date()
        var endTime = Date()
        var town = ""
        var time: TimeInterval = 10000
        var timeString: String = ""
        var isON = false
        var isButtonDisabled = true

        public init() {}
    }
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
        case timerTick
        case startTimer
        case dismiss
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
                return .none

            case .startTimer:
                return .run { send in
                    await self.startTimer(send: send)
                }

            case .timerTick:
                state.time -= 1
                state.timeString = state.time.format()
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

extension TimeInterval {

    var days: Int { Int(self) / (3600 * 24) }
    var hours: Int { (Int(self) / 3600) % 24 }
    var minutes: Int { Int(self) / 60 % 60 }
    var seconds: Int { Int(self) % 60 }

    var isLongerThanDay: Bool { days > 0 }

    func format() -> String {
        guard self >= 0 else { return "" }

        if isLongerThanDay {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM HH:mm"
            return String.from(Date().addingTimeInterval(self))
        }

        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

}

private func convert(timeInterval: Double) -> String {
        let hours = Int(timeInterval) / 60
        let minutes = Int(timeInterval) % 60
        return String(format: "%02i:%02i", hours, minutes)
}

extension String {

    static func from(_ date: Date, timeZone: TimeZone? = nil) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0) ?? .current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        return String(format: "%02i:%02i", hour, minute)
    }

}
