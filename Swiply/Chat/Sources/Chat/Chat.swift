import SwiftUI
import ComposableArchitecture

public struct ChatFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        public var chat = PersonalChatModel.chatSample
        var matches = Matches.matchesSample.sorted { $0.isViewed == !$1.isViewed}
        var selectedIndex = 0
        var multiUserChat = MultiUserChatModel.chatSample
        public init() { }
    }
    
    public enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case tapOnMatch(Matches)
        case tapOnChat(PersonalChatModel)
        case tapOnMultiUserChat(MultiUserChatModel)
        case showChat(PersonalChatModel)
        case showMultiUserChat(MultiUserChatModel)
        case mute(PersonalChatModel)
        case delete(PersonalChatModel)
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
                        PersonalChatModel(
                            person: match.person,
                            messages: [],
                            unreadMessage: false
                        )
                    ))
                }
            case let .tapOnChat(chat):
                let openChat: PersonalChatModel
                if let index = state.chat.firstIndex(where: { $0.id == chat.id }) {
                    state.chat[index].unreadMessage = false
                    openChat = state.chat[index]
                } else {
                    openChat = chat
                }
                return .run { send in
                    await send(.showChat(openChat))
                }
            case let .tapOnMultiUserChat(chat):
                let openChat: MultiUserChatModel
                if let index = state.multiUserChat.firstIndex(where: { $0.id == chat.id }) {
                    state.multiUserChat[index].unreadMessage = false
                    openChat = state.multiUserChat[index]
                } else {
                    openChat = chat
                }
                return .run { send in
                    await send(.showMultiUserChat(openChat))
                }
            case .showMultiUserChat:
                return .none
            case .showChat:
                return .none
            case let .mute(chat):
                if let index = state.chat.firstIndex(where: { $0.id == chat.id }) {

                    state.chat[index].isMuted.toggle()
                }
                return .none
            case let .delete(chat):
                if let index = state.chat.firstIndex(where: { $0.id == chat.id }) {
                    state.chat.remove(at: index)
                  
                }
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
                Text("Чаты")
                    .bold()
                    .font(.headline)
                    .foregroundStyle(.pink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                SegmentedView(
                    segments:  ["Личные", "Групповые"],
                    selected:  $store.selectedIndex
                )
                .padding(.top, 10)
                if store.selectedIndex == 0 {
                    ForEach(configureChats(store.chat)) { chat in
                        ChatRow(chat: chat) { chat in
                            store.send(.tapOnChat(chat))
                        } delete: { chat in
                            store.send(.delete(chat))
                        } mute: { chat in
                            store.send(.mute(chat))
                        }
                    }
                } else {
                    ForEach(configureChats(chats: store.multiUserChat)) { chat in
                        MultiUserChatRow(chat: chat) { chat in
                            store.send(.tapOnMultiUserChat(chat))
                        }
                    }
                }
            }
        }
    }
    
    func configureMatches(_ matches: [Matches], _ chats: [PersonalChatModel]) -> [Matches]? {
        var newMatches = [Matches]()
        matches.forEach { match in
            if !chats.contains(where: { $0.person.id == match.person.id }) {
                newMatches.append(match)
            }
        }
        return newMatches.isEmpty ? nil : newMatches
    }
    
    func configureChats(_ chats: [PersonalChatModel]) -> [PersonalChatModel] {
        chats.sorted {
            $0.messages.last?.date ?? Date() > $1.messages.last?.date ?? Date()
        }
    }
    
    func configureChats(chats: [MultiUserChatModel]) -> [MultiUserChatModel] {
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

public struct SegmentedPicker<Element, Content, Selection>: View
    where
    Content: View,
    Selection: View {

    public typealias Data = [Element]

    @State private var frames: [CGRect]
    @Binding private var selectedIndex: Int

    private let data: Data
    private let selection: () -> Selection
    private let content: (Data.Element, Bool) -> Content

        public init( data: Data,
                        selectedIndex: Binding<Int>,
                        @ViewBuilder content: @escaping (Data.Element, Bool) -> Content,
                        @ViewBuilder selection: @escaping () -> Selection) {

                self.data = data
                self.content = content
                self.selection = selection
                self._selectedIndex = selectedIndex
                self._frames = State(wrappedValue: Array(repeating: .zero,
                                                         count: data.count))
            }

    public var body: some View {
        ZStack(alignment: Alignment(horizontal: .horizontalCenterAlignment,
                                    vertical: .center)) {

//            if let selectedIndex = selectedIndex {
                selection()
                    .frame(width: frames[selectedIndex].width,
                           height: frames[selectedIndex].height)
                    .alignmentGuide(.horizontalCenterAlignment) { dimensions in
                        dimensions[HorizontalAlignment.center]
                    }
//            }

            HStack(spacing: 0) {
                ForEach(data.indices, id: \.self) { index in
                    Button(action: { selectedIndex = index },
                           label: { content(data[index], selectedIndex == index) }
                    )
                    .buttonStyle(PlainButtonStyle())
                    .background(GeometryReader { proxy in
                        Color.clear.onAppear { frames[index] = proxy.frame(in: .global) }
                    })
                    .alignmentGuide(.horizontalCenterAlignment,
                                    isActive: selectedIndex == index) { dimensions in
                        dimensions[HorizontalAlignment.center]
                    }
                }
            }
        }
    }
}

extension HorizontalAlignment {
    private enum CenterAlignmentID: AlignmentID {
        static func defaultValue(in dimension: ViewDimensions) -> CGFloat {
            return dimension[HorizontalAlignment.center]
        }
    }
    
    static var horizontalCenterAlignment: HorizontalAlignment {
        HorizontalAlignment(CenterAlignmentID.self)
    }
}

extension View {
    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: HorizontalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {
        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }

    @ViewBuilder
    @inlinable func alignmentGuide(_ alignment: VerticalAlignment,
                                   isActive: Bool,
                                   computeValue: @escaping (ViewDimensions) -> CGFloat) -> some View {

        if isActive {
            alignmentGuide(alignment, computeValue: computeValue)
        } else {
            self
        }
    }
}

struct SegmentedView: View {

    let segments: [String]
    @Binding var selected: Int
    @Namespace var name

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selected = segments.firstIndex(of: segment) ?? 0
                    }
                } label: {
                    VStack {
                        Text(segment)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(segments[selected] == segment ? .pink.opacity(0.7) : .black)
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if segments[selected] == segment {
                                Capsule()
                                    .fill(Color.pink.opacity(0.7))
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
        }
    }
}
