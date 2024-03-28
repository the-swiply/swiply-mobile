import SwiftUI
import ComposableArchitecture

public struct ChatFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        public var chat = ChatModel.chatSample
        var matches = Matches.matchesSample.sorted { $0.isViewed == !$1.isViewed}
        
        public init() { }
    }
    
    public enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case tapOnMatch(Matches)
        case tapOnChat(ChatModel)
        case showChat(ChatModel)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .tapOnMatch(match):
                if let index = state.matches.firstIndex(where: { $0.id == match.id }) {
                    if !state.matches[index].isViewed {
                        state.matches[index].isViewed = true
                        state.matches.move(fromOffsets: IndexSet(arrayLiteral: index), toOffset: state.matches.count)
                    }
                }
                return .run { send in
                    await send(.showChat(
                        ChatModel(
                            person: match.person,
                            messages: [],
                            unreadMessage: false
                        )
                    ))
                }
            case let .tapOnChat(chat):
                let openChat: ChatModel
                if let index = state.chat.firstIndex(where: { $0.id == chat.id }) {
                    state.chat[index].unreadMessage = false
                    openChat = state.chat[index]
                } else {
                    openChat = chat
                }
                return .run { send in
                    await send(.showChat(openChat))
                }
            case .showChat:
                return .none
            }
        }
    }
    
  
}

struct ChatView: View {
    
    @Bindable var store: StoreOf<ChatFeature>
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(.mainBarLogo)
                    .padding(.top, 10)
            }
           
            ScrollView {
                if let matches = configureMatches(store.matches, store.chat) {
                    MatchesRow(matches: matches) { match in
                        store.send(.tapOnMatch(match))
                    }
                    .padding(.bottom)
                }
                Text("Сообщения")
                    .bold()
                    .font(.subheadline)
                    .foregroundStyle(.pink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                ForEach(configureChats(store.chat)) { chat in
                    ChatRow(chat: chat) { chat in
                        store.send(.tapOnChat(chat))
                    }
                }
            }
        }
    }
    
    func configureMatches(_ matches: [Matches], _ chats: [ChatModel]) -> [Matches]? {
        var newMatches = [Matches]()
        matches.forEach { match in
            if !chats.contains(where: { $0.person.id == match.person.id }) {
                newMatches.append(match)
            }
        }
        return newMatches.isEmpty ? nil : newMatches
    }
    
    func configureChats(_ chats: [ChatModel]) -> [ChatModel] {
        chats.sorted {
            $0.messages.last?.date ?? Date() > $1.messages.last?.date ?? Date()
        }
    }
}

#Preview {
    ChatView(
        store: Store(
            initialState: ChatFeature.State(),
            reducer: { ChatFeature()._printChanges() }
        )
    )
}
