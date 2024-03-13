import SwiftUI
import SYVisualKit
import ComposableArchitecture

public struct WelcomeView: View {

    @Bindable var store: StoreOf<Welcome>

    // MARK: - View

    public var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(.logo)

            Text("Добро пожаловать в Swiply!")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Spacer()

            SYButton(title: "Войти") {
                store.send(.continueButtonTapped)
            }
            .padding(.all, 24)
        }
    }
    
}

#Preview {
    WelcomeView(
        store: Store(initialState: Welcome.State()) {
            Welcome()
        }
    )
}
