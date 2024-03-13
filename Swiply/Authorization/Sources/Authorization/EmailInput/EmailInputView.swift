import SwiftUI
import SYVisualKit
import ComposableArchitecture

struct EmailInputView: View {
    
    @Bindable var store: StoreOf<EmailInput>
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 95) {
            SYTextField(
                placeholder: "Email",
                footerText: "Мы отправим текстовое сообщение с кодом подтверждения",
                text: $store.text.sending(\.textChanged)
            )
            
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .padding(.horizontal, 24)
            .disabled(store.isContinueButtonDisabled)
        }
    }
    
}

#Preview {
    EmailInputView(
        store: Store(initialState: EmailInput.State()) {
            EmailInput()._printChanges()
        }
    )
}
