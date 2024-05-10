import SwiftUI
import SYVisualKit
import ComposableArchitecture

public struct OTPView: View {

    @Bindable var store: StoreOf<OTP>

    public init(store: StoreOf<OTP>) {
        self.store = store
    }

    // MARK: - View

    public var body: some View {
        VStack {
            Spacer()

            SYOTPTextField(
                isDestructive: store.isIncorrectCodeEntered,
                isFullfilled: $store.isFullfilled.sending(\.binding),
                text: $store.code.sending(\.textChanged)
            )

            Spacer()

            VStack(spacing: 35) {
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
        }
        .padding(.all, 24)
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
            OTP()._printChanges()
        }
    )
}
