import SwiftUI
import ComposableArchitecture
import Authorization

struct RootView: View {

    @Bindable var store: StoreOf<Root>

    var body: some View {
        if store.destination == nil {
            SplashScreenView()
        }
        IfLetStore(store.scope(state: \.destination?.authorization, action: \.destination.authorization)) { store in
            AuthorizationRootView(store: store)
        }
    }

}
