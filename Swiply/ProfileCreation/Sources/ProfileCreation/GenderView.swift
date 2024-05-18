import SwiftUI
import ComposableArchitecture
import SYVisualKit
import ProfilesService
import SYCore

public struct GenderFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("CreatedProfile")) var profile = CreatedProfile()
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
                state.profile.gender = state.gender
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
    
    @Bindable var store: StoreOf<GenderFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            SYHeaderView(
                title: "Мой пол",
                desription: "Выберите свой пол"
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
        store: Store(initialState: GenderFeature.State(), reducer: {
            GenderFeature()._printChanges()
        })
    )
}
