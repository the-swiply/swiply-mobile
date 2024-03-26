import SwiftUI
import SYVisualKit
import ComposableArchitecture

struct OTPView: View {

    @Bindable var store: StoreOf<OTP>

    // MARK: - View

    var body: some View {
        VStack(spacing: 30) {
            SYOTPTextField(
                isDestructive: $store.isIncorrectCodeEntered.sending(\.binding),
                isFullfilled: $store.isFullfilled.sending(\.binding),
                text: $store.code.sending(\.textChanged)
            )

            switch store.isRetryButtonDisabled {
            case .enabled:
                SYStrokeButton(title: "Отправить код заново") {
                    store.send(.retryButtonTapped)
                }
                .tint(.black)

            case let .disabled(remainingTime):
                SYStrokeButton(title: "Отправить код заново: \(remainingTime)") {
                    store.send(.retryButtonTapped)
                }
                .tint(.black)
                .disabled(true)
            }

            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
        }
        .padding(.horizontal, 24)
        .navigationTitle("Мой Код")
        .navigationBarTitleDisplayMode(.large)
        .task {
            store.send(.toggleTimer(isOn: false))
        }
    }

}

#Preview {
    OTPView(
        store: Store(initialState: OTP.State()) {
            OTP()
        }
    )
}
