import SwiftUI
import SYVisualKit
import ComposableArchitecture

struct ChatRow: View {
    
    let chat: PersonalChatModel
    let action: (PersonalChatModel) -> Void
    let delete: (PersonalChatModel) -> Void
    let mute: (PersonalChatModel) -> Void
    @State private var showingPopover = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 20) {
                    Image(uiImage: chat.person.images.first!!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    //                .overlay(Circle().stroke(.pink, lineWidth: 1))
                        .shadow(radius: 1)
                    
                    ZStack {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(chat.person.name)
                                    .bold()
                                if chat.isMuted {
                                    Image(systemName: "speaker.slash")
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(chat.messages.last?.text ?? "")
                                    .foregroundStyle(.gray)
                                    .lineLimit(1)
                                    .frame(height: 20, alignment: .center)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.trailing, 40)
                                
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
