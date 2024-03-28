import SwiftUI
import ComposableArchitecture
import SYVisualKit
import UserService

public struct GenderFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var selectedDate = Date()
        var isContinueDisabled = true
        var isFirstSelected = false
        var isSecondSelected = false
        var gender: Gender = .none
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
        case genderButtonTapped(Gender)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .continueButtonTapped:
                return .none
            case let .genderButtonTapped(value):
                state.gender = value
                state.isContinueDisabled = false
                state.isFirstSelected = !(value == .male)
                state.isSecondSelected = value == .male
                return .none
            }
        }
    }
}


struct GenderView: View {
    
    var title: String
    var description: String
    @Bindable var store: StoreOf<GenderFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            SYHeaderView(
                title: title,
                desription: description
            )
            
            SYStrokeButton(title: "Женщина") {
                store.send(.genderButtonTapped(.female))
            }
            .padding(.bottom, 20)
            .foregroundStyle(store.isFirstSelected ? .pink : .gray)
            SYStrokeButton(title: "Мужчина") {
                store.send(.genderButtonTapped(.male))
            }
            .foregroundStyle(store.isSecondSelected ? .pink : .gray)
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .disabled(store.isContinueDisabled)
            .padding(.top, 68)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    GenderView(
        title: "Мой пол",
        description: "Выберите свой пол",
        store: Store(initialState: GenderFeature.State(), reducer: {
            GenderFeature()._printChanges()
        })
    )
}
