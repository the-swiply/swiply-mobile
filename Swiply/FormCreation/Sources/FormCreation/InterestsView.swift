import SwiftUI
import SYVisualKit
import ComposableArchitecture

public struct InterestsReducer: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var selectedInterests = Set<String>()
        var isButtonDisabled = true
    }
    
    public enum Action: Equatable {
        case continueButtonTapped
        case interestButtonTapped(String)
        case changeButtonState
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .none
            case let .interestButtonTapped(interest):
                if state.selectedInterests.contains(interest) {
                    state.selectedInterests.remove(interest)
                } else {
                    state.selectedInterests.insert(interest)
                }
                return .run { send in
                    await send(.changeButtonState)
                }
            case .changeButtonState:
                state.isButtonDisabled = state.selectedInterests.isEmpty
                return .none
            }
        }
    }
}

struct InterestsView: View {
    
    var store: StoreOf<InterestsReducer>
    
    var body: some View {
        VStack(alignment: .leading) {
            SYHeaderView(
                title: "Интересы",
                desription: "Добавь в профиль свои интересы, так ты сможешь найти людей с общими интересами"
            )
            SYChipsContent(action: { str in
                store.send(.interestButtonTapped(str))
            })
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .disabled(store.isButtonDisabled)
            .padding(.top, 5)
            Spacer()
           
        
        }
        .padding(.horizontal, 24)
    }
}

struct InterestsView_Preview: PreviewProvider {
    static var previews: some View {
        InterestsView(store: Store(initialState: InterestsReducer.State(), reducer: {
            InterestsReducer()
                ._printChanges()
        }))
    }
}
