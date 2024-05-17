import SwiftUI
import SYVisualKit
import ComposableArchitecture
import ProfilesService
import SYCore
public struct InterestsFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("CreatedProfile")) var profile = CreatedProfile()
        var selectedInterests = Set<Interest>()
        var isButtonDisabled = true
        var interests: [Interest] = []
    }
    
    public enum Action: Equatable {
        case continueButtonTapped
        case interestButtonTapped(Interest)
        case changeButtonState
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                state.profile.interests = state.selectedInterests.map { $0 }
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
    
    var store: StoreOf<InterestsFeature>

    var body: some View {
        VStack(alignment: .leading) {
            
            SYHeaderView(
                title: "Интересы",
                desription: "Добавь в профиль свои интересы, так ты сможешь найти людей с общими интересами"
            )
            .padding(.horizontal, 8)
            
            SYFlowView(
                content: store.interests.map { interest in
                    SYChip(text: interest.definition) { text in
                        if let interest = store.interests.first(where: { $0.definition == text}) {
                            store.send(.interestButtonTapped(interest))
                        }
                    }
                }
            )
            .padding(.bottom, 35)
            
            Spacer()
            
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .disabled(store.isButtonDisabled)
            .padding(.top, 5)
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 16)
    }
}

struct InterestsView_Preview: PreviewProvider {
    static var previews: some View {
        InterestsView(store: Store(initialState: InterestsFeature.State(), reducer: {
            InterestsFeature()
                ._printChanges()
        }))
    }
}
