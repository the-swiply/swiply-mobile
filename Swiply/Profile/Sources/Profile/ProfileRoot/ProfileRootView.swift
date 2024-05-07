import SwiftUI
import ComposableArchitecture
import Authorization

public struct ProfileRootView: View {
    @Bindable var store: StoreOf<ProfileRoot>
    
    public init(store: StoreOf<ProfileRoot>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ProfileView(store: store.scope(state: \.profile, action: \.profile))
        } destination: { store in
            switch store.case {
            case let .edit(store):
                EditView(store: store)
            case let .settings(store):
                SettingsView(store: store)
            case let .emailConformation(store):
                AuthorizationRootView(store: store)
            }
        }
    }
}
