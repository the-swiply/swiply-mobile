import SwiftUI
import ComposableArchitecture
import Authorization
import FormCreation

struct RootView: View {

    @Bindable var store: StoreOf<Root>

    var body: some View {
        if store.destination == nil {
            SplashScreenView()
        }
        IfLetStore(store.scope(state: \.destination?.authorization, action: \.destination.authorization)) { store in
            AuthorizationRootView(store: store)
        }
        
        IfLetStore(store.scope(state: \.destination?.formCreation, action: \.destination.formCreation)) { store in
            FormCreationRootView(store: store)
        }
    }

}
