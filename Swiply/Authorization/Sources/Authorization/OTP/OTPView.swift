import SwiftUI
import SYVisualKit
import ComposableArchitecture

struct OTPView: View {

    @Bindable var store: StoreOf<OTP>

    @State private var text: String = ""
    @State private var isDestructive: Bool = false
    @State private var isFullfilled: Bool = false

    // MARK: - View

    var body: some View {
        VStack(spacing: 30) {
            SYOTPTextField(
                isDestructive: $isDestructive,
                isFullfilled: $isFullfilled,
                text: $text
            )

            SYStrokeButton(title: "Отправить код заново") {
                
            }
            .tint(.black)

            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
        }
        .padding(.horizontal, 24)
    }

}

#Preview {
    OTPView(
        store: Store(initialState: OTP.State(remainingTime: nil)) {
            OTP()
        }
    )
}
