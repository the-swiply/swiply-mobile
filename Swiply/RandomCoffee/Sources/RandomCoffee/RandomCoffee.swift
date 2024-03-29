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
                return .none

            case .continueButtonTapped:
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

public struct RandomCoffeeView: View {
    
    @Bindable var store: StoreOf<RandomCoffeeFeature>
    
    public init(store: StoreOf<RandomCoffeeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            HStack(alignment: .center) {
                Image(.randomCoffee)
                    .resizable()
                    .frame(width: 50, height: 40)
                
                Text("Random Coffee")
                    .padding(.leading)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .gradientForeground(colors: [.pink, .purple])
                
            }
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 100)
                    .foregroundStyle(.pink.opacity(0.6))
                    .padding(3)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.pink.opacity(0.5), lineWidth: 3)
                        
                    }
                    .gradientForeground(colors: [.pink, .purple])
                Text("Выберите удобное время для встречи завтра. А мы найдём вам компанию с вашей работы или института.")
                    .bold()
                    .foregroundStyle(.white)
                
            }
            .padding(.top, 30)
            HStack(spacing: 0) {
                Text("Время начала встречи")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker(
                    selection: $store.startTime,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
                
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 30)
            
            HStack(spacing: 0) {
                Text("Время конца встречи")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker(
                    selection: $store.endTime,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 10)
            
            VStack(alignment: .leading) {
                
                TextField("Город встречи", text: $store.town)
                    .padding(15)
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.top, 30)

            Text(store.timeString)

            Spacer()
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .padding(.bottom, 50)
            
        }
        .padding(.horizontal, 24)
        .task {
            store.send(.startTimer)
        }

    }
}

#Preview {
    RandomCoffeeView(
        store: Store(initialState: RandomCoffeeFeature.State(), reducer: {
            RandomCoffeeFeature()._printChanges()
        })
    )
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
        .mask(self)
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
