import SwiftUI
import SYVisualKit
import ComposableArchitecture
import ProfilesService
public struct InterestsReducer: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        @Shared(.inMemory("CreatedProfile")) var profile = CreatedProfile()
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
    
    var store: StoreOf<InterestsReducer>

    private let interests = ["ios" ,"android" ,"путешествия" ,"велосипед" ,"кулинария" ,"животные" ,"музыка"  ,"тeaтp"  ,"it" ,"суши" ,"книги"  ,"йога" ,"фотография" ,"стендап" ,"ландшафтный дизайн" , "тату", "иностранные языки" ,"танцы" ,"восточные танцы" ,"спорт","пошив одежды", "медитации", "бег" ,"здоровый образ жизни", "пицца"]

    var body: some View {
        VStack(alignment: .leading) {
            SYHeaderView(
                title: "Интересы",
                desription: "Добавь в профиль свои интересы, так ты сможешь найти людей с общими интересами"
            )
//            .padding(.top, 80)
            .padding(.horizontal, 8)
            
            SYFlowView(
                content: interests.map { interest in
                    SYChip(text: interest) { text in
                        store.send(.interestButtonTapped(text))
                    }
                }
            )
           .padding(.bottom, 35)
         
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .disabled(store.isButtonDisabled)
            .padding(.top, 5)
            .padding(.horizontal, 8)
            Spacer()
  
        }
        .padding(.horizontal, 16)
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
