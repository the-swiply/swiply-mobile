import XCTest
@testable import FormCreation
import ComposableArchitecture

final class ProfileCreationTests: XCTestCase {
    
    @MainActor
    func test_changeInterests() async {
        let store = TestStore(
          initialState: InterestsReducer.State()
        ) {
            InterestsReducer()
        }
        
        // Пользователь выбрал интерес "ios". Он добавлен в сет.
        await store.send(.interestButtonTapped("ios")) {
            $0.selectedInterests = ["ios"]
        }
        
        // Кнопка стала активной
        await store.receive(.changeButtonState) {
            $0.isButtonDisabled = false
        }
       
        // Пользователь выбрал интерес "music". Он добавлен в сет.
        await store.send(.interestButtonTapped("music")) {
            $0.selectedInterests = ["ios", "music"]
        }
        
        // Состояние кнопки не изменилось
        await store.receive(.changeButtonState)
        
        // Пользователь отменил выбор интереса "ios". Он удалился из сета, но интерес "music" остался.
        await store.send(.interestButtonTapped("ios")) {
            $0.selectedInterests = ["music"]
        }
        
        // Состояние кнопки не изменилось, так как выбран один интерес.
        await store.receive(.changeButtonState)
        
        // Пользователь отменил выбор интереса "music". Он удалился из сета.
        await store.send(.interestButtonTapped("music")) {
            $0.selectedInterests = []
        }
        
        // Кнопка стала не активной, так как пользователь должен выбрать хотя бы один интерес
        await store.receive(.changeButtonState) {
            $0.isButtonDisabled = true
        }
    }
}
