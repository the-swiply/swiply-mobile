import SwiftUI
import ComposableArchitecture

public struct SettingsFeature: Reducer {
    
    @ObservableState
    public struct State: Equatable {
        var matchNotification = true
        var messagesNotification = true
        var likesNotification = true
        var meetingNotification = true
        
        public init() {}
    }
    
    @Dependency(\.dismiss) var dismiss
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case saveButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            case .binding:
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
                        Text("Уведомлять о встречи")
                    })
                }
                
                Text("Выйти")
            }
            //
            
      
       
        }
  
        .navigationBarTitle(Text("Settings"))
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
    }
}

#Preview {
    NavigationView {
        SettingsView(
            store: Store(initialState: SettingsFeature.State(), reducer: {
                SettingsFeature()._printChanges()
            })
        )
    }
}
