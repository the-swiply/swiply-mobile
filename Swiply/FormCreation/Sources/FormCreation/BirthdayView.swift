import SwiftUI
import ComposableArchitecture
import SYVisualKit
import ProfilesService

public struct BirthdayFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("CreatedProfile")) var profile = CreatedProfile()
        var selectedDate = Date()
   
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .continueButtonTapped:
                state.profile.age = state.selectedDate
                return .none
            }
        }
    }
}

struct BirthdayView: View {
    
    var title: String
    var description: String
    @Bindable var store: StoreOf<BirthdayFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            SYHeaderView(
                title: title,
                desription: description
            )
            
            DatePicker(
                selection: $store.selectedDate,
                displayedComponents: [.date], label: {
                    
                })
            .datePickerStyle(.wheel)
            .environment(\.locale, Locale.init(identifier: "ru"))
            
            .pickerStyle(.wheel)
            .padding(.top, 30)
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .padding(.top, 24)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    BirthdayView(
        title: "Мой День рождения",
        description: "Ваш возраст будет указан в профиле", 
        store: Store(initialState: BirthdayFeature.State(), reducer: {
            BirthdayFeature()._printChanges()
        })
    )
}
