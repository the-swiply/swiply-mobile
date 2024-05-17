import SwiftUI
import ComposableArchitecture


public struct PersonalChatFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var chat = PersonalChatModel.chatSample[0]
        var text = ""
        var messageIDScroll: UUID?
    }
    
    public enum Action: BindableAction, Equatable  {
        case binding(BindingAction<State>)
        case sendMessage(String)
        case update(PersonalChatModel)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .sendMessage(message):
                let mess = Message(message, type: .sent, isViewed: true, person: .tima)
                state.chat.messages.append(mess)
                state.text = ""
                state.messageIDScroll = mess.id
                let chat = state.chat
                return  .run { send in
                    await send(.update(chat))
                }
            case .update:
                return .none
            }
        }
    }
}


struct PersonalChat: View {
    
    @Bindable var store: StoreOf<PersonalChatFeature>
    @FocusState private var isFocused
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { reader in
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessagesView(width: reader.size.width)
                            .padding(.horizontal, 5)
                            .onChange(of: store.messageIDScroll) { _ in
                                if let messageID = store.messageIDScroll {
                                    scrollTo(messageID: messageID, animate: true, scrollReader: scrollReader)
                                }
                            }
                            .onAppear {
                                if let messageID = store.chat.messages.last?.id {
                                    scrollTo(messageID: messageID, anchor: .bottom, animate: true, scrollReader: scrollReader)
                                }
                            }
                    }
                }
                
            }
            .padding([.bottom], 5)
            
            toolbarView()
        }
        .padding(.top, 1)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                VStack {
                    HStack {
                        Image(uiImage: store.chat.person.images.first!!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                        
                        Text(store.chat.person.name)
                            .bold()
                        
                    }
                    
                    
                }.padding()
            }
            
            
            
        })
    }
    
    func scrollTo(messageID: UUID, anchor: UnitPoint? = nil, animate: Bool, scrollReader: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(animate ? .easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: anchor)
            }
        }
    }
    
    func toolbarView() -> some View {
        VStack {
            HStack {
                TextField("Отправь сообщение", text: $store.text)
                    .padding(.horizontal, 10)
                    .frame(height: 37)
                    .background(.white)
                
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocused)
                
                Button(action: {
                    store.send(.sendMessage(store.text))
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .frame(width: 37, height: 37)
                        .foregroundStyle(
                            store.text.isEmpty ? .gray : .pink
                        )
                })
                .disabled(store.text.isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(.thinMaterial)
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    func getMessagesView(width: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(store.chat.messages) { message in
                let isReceived = message.type == .received
                HStack(spacing: 0) {
                    ZStack {
                        Text(message.text)
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .foregroundStyle(isReceived ? .black : .white)
                            .background(isReceived ? .gray.opacity(0.1) : .pink.opacity(0.8))
                            .cornerRadius(13)
                    }
                    .frame(width: width * 0.7, alignment: isReceived ? .leading : .trailing)
                    .padding([.vertical, .horizontal], 5)
                    
                }
                .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing )
                .id(message.id)
            }
        }
    }
}

#Preview {
    NavigationView {
        PersonalChat(
            store: Store(
                initialState: PersonalChatFeature.State(),
                reducer: { PersonalChatFeature()._printChanges() }
            )
        )
    }
}
