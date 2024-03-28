import SwiftUI
import ComposableArchitecture

public struct ChatRootView: View {
    @Bindable var store: StoreOf<ChatRoot>
    
    public init(store: StoreOf<ChatRoot>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            ChatView(store: store.scope(state: \.chats, action: \.chats))
        } destination: { store in
            switch store.case {
            case let .personalChat(store):
                PersonalChat(store: store)
            }
        }
    }
}
