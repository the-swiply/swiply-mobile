import SwiftUI
import ComposableArchitecture
import Authorization
import FormCreation
import MainScreen
import Chat
import Profile

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
        IfLetStore(store.scope(state: \.destination?.main, action: \.destination.main)) { store in
            MainRootView(store: store)
        }
        
        IfLetStore(store.scope(state: \.destination?.chat, action: \.destination.chat)) { store in
            ChatRootView(store: store)
        }
        
        IfLetStore(store.scope(state: \.destination?.profile, action: \.destination.profile)) { store in
            ProfileRootView(store: store)
        }
    }

}
