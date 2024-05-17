import SwiftUI
import ComposableArchitecture

public struct SettingsFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var matchNotification = true
        var messagesNotification = true
        var likesNotification = true
        var meetingNotification = true

        public init(match: Bool, messages: Bool, likes: Bool, meeting: Bool) {
            self.matchNotification = match
            self.messagesNotification = messages
            self.likesNotification = likes
            self.meetingNotification = meeting
        }
        
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.profileManager) var profileManager
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveButtonTapped
        case exitButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                profileManager.setLikeNotification(state.likesNotification)
                profileManager.setMatchNotification(state.matchNotification)
                profileManager.setMeetingNotification(state.meetingNotification)
                profileManager.setMessageNotification(state.messagesNotification)
                return .run { _ in
                    await self.dismiss()
                }
            case .binding:
                return .none
            case .exitButtonTapped:
                return .none
            }
        }
    }
}


struct SettingsView: View {
    
    @Bindable var store: StoreOf<SettingsFeature>
    
    var body: some View {
        VStack {
            Form {
                Section("Уведомления") {
                    Toggle(isOn: $store.matchNotification, label: {
                        Text("Уведомлять о метчах")
                    })
                    Toggle(isOn: $store.messagesNotification, label: {
                        Text("Уведомлять о новых сообщениях")
                    })
                    Toggle(isOn: $store.likesNotification, label: {
                        Text("Уведомлять о новых лайках")
                    })
                    
                    Toggle(isOn: $store.meetingNotification, label: {
                        Text("Уведомлять о встречах")
                    })
                }
                
                Text("Выйти")
                    .onTapGesture {
                        store.send(.exitButtonTapped)
                    }
            }
       
        }
  
        .navigationBarTitle(Text("Настройки"))
        .navigationBarItems(
            trailing:
                Button(
                    action: {
                        store.send(.saveButtonTapped)
                    },
                    label: {
                        Text("Сохранить")
                    }
                )
        )
        .environment(\.locale, Locale.init(identifier: "ru"))
    }
}
