import SwiftUI
import SYCore

struct MultiUserChatRow: View {
    
    let chat: MultiUserChatModel
    let action: (MultiUserChatModel) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 20) {
                    ZStack {
                        Circle().gradientForeground(colors: [.pink, .purple])
                            .frame(width:70, height: 70)
                        Image(uiImage: chat.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .padding(2)
                                    .overlay(Circle().stroke(.white, lineWidth: 2))
                                
                                    .shadow(radius: 1)
                    }
                    ZStack {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(chat.title)
                                    .bold()
                                Spacer()
                            }
                            
                            if let message = chat.messages.last {
                                HStack {
                                    Text(message.person.name)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                        .frame(height: 20, alignment: .center)
                                    Text(message.text)
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                        .frame(height: 20, alignment: .center)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing, 40)
                                    
                                }
                            }
                        }
                        
                        Circle()
                            .foregroundStyle(chat.unreadMessage ? .pink : .clear)
                            .frame(width: 18, height: 18)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    
                }
                .frame(height: 80)
                .padding(.horizontal)
            }
            .onTapGesture {
                action(chat)
            }
            Divider()
                .padding(.leading, 90)
                .padding(.trailing)
        }
        
    }
}
