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

            Button("Crash") {
              fatalError("Crash was triggered")
            }
            Button("Crash 2") {
                let str: String? = nil
                let str2 = str!
            }
            
            Button("Crash 3") {
                let str = []
                let str2 = str[1]
            }
//            SYButton(title: "Войти") {
//                store.send(.continueButtonTapped)
//            }
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
