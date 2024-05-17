import ComposableArchitecture
import SwiftUI

@Reducer

public struct ChatRoot {
    
    @Reducer(state: .equatable)
    public enum Path {
        case personalChat(PersonalChatFeature)
        case multiUserChat(MultiUserChatFeature)
    }
    
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
        public var chats = ChatFeature.State()
        
        public init(path: StackState<Path.State> = StackState<Path.State>(), chats: ChatFeature.State = ChatFeature.State()) {
            self.path = path
            self.chats = chats
        }
    }
    
    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case chats(ChatFeature.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.chats, action: \.chats) {
            ChatFeature()
        }
        Reduce { state, action in
            switch action {
            case let .chats(action):
                switch action {
                case let .showChat(chat):
                    state.path.append(.personalChat(PersonalChatFeature.State(chat: chat)))
                case let .showMultiUserChat(chat):
                    state.path.append(.multiUserChat(MultiUserChatFeature.State(chat: chat)))
                default:
                    break
                }
                
                return .none
        
            case .path(.element(_, let .personalChat(.update(chat)))):
                
                if let index = state.chats.chat.firstIndex(where: { $0.id == chat.id }) {
                    state.chats.chat[index] = chat
                } else {
                    state.chats.chat.append(chat)
                }
                return .none
            case .path(.element(_, let .multiUserChat(.update(chat)))):
                if let index = state.chats.multiUserChat.firstIndex(where: { $0.id == chat.id }) {
                    state.chats.multiUserChat[index] = chat
                } else {
                    state.chats.multiUserChat.append(chat)
                }
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
