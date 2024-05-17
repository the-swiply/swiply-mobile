import SwiftUI
import SYVisualKit
import ComposableArchitecture

public struct EmailInputView: View {

    @Bindable var store: StoreOf<EmailInput>
    @State var isValid = true
    @FocusState private var isTextFieldFocused: Bool

    public init(store: StoreOf<EmailInput>) {
        self.store = store
    }
    
    // MARK: - View
    
    public var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading) {
                SYTextField(
                    placeholder: "Email",
                    footerText: "Мы отправим текстовое сообщение с кодом подтверждения",
                    text: $store.text.sending(\.textChanged)
                )
                .focused($isTextFieldFocused)
                .keyboardType(.emailAddress)

                Text("Некорректная почта")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle( isValid ? .clear : .red)
                    .padding(.top, 10)
            }
            
            Spacer()

            SYButton(title: "Продолжить") {
                isValid = isValidEmail(store.text)
                if isValid {
                    store.send(.continueButtonTapped)
                }
               
            }
            .disabled(store.isContinueButtonDisabled)
        }
        .padding(.all, 24)
        .navigationTitle("Мой Email")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}

#Preview {
    EmailInputView(
        store: Store(initialState: EmailInput.State()) {
            EmailInput()._printChanges()
        }
    )
}
