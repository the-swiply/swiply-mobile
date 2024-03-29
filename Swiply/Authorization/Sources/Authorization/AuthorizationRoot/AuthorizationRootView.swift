import SwiftUI
import ComposableArchitecture
import FormCreation

public struct AuthorizationRootView: View {

    @Bindable var store: StoreOf<AuthorizationRoot>

    public init(store: StoreOf<AuthorizationRoot>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(
          path: $store.scope(state: \.path, action: \.path)
        ) {
            WelcomeView(
                store: store.scope(state: \.welcome, action: \.welcome)
            )
        } destination: { store in
            switch store.case {
            case let .createProfile(store):
                FormCreationRootView(store: store)
            case let .emailInput(store):
                EmailInputView(store: store)

            case let .otp(store):
                OTPView(store: store)
            }
        }
    }

}
