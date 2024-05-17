import SwiftUI
import ComposableArchitecture
import SYVisualKit
import SYCore

public struct RandomCoffeeView: View {
    
    @Bindable var store: StoreOf<RandomCoffeeFeature>
    
//    private let org = ["НИУ ВШЭ", "Яндекс"]
    public init(store: StoreOf<RandomCoffeeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            HStack(alignment: .center) {
                Image(.randomCoffee)
                    .resizable()
                    .frame(width: 50, height: 40)
                
                Text("Random Coffee")
                    .padding(.leading)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .gradientForeground(colors: [.pink, .purple])
                
            }
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 100)
                    .foregroundStyle(.pink.opacity(0.6))
                    .padding(3)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.pink.opacity(0.5), lineWidth: 3)
                        
                    }
                    .gradientForeground(colors: [.pink, .purple])
                Text("Выберите удобное время для встречи завтра. А мы найдём вам компанию с вашей работы или института.")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                
            }
            .padding(.top, 10)
            .padding(.bottom, 30)
            
            HStack(spacing: 0) {
                HStack {
                    Text("Организация")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    Picker("Организация",
                           selection: $store.organization) {
                        ForEach(store.user.corporateMail, id: \.self) {
                            Text($0.name).tag($0)
                        }
                    }
                }
                
            }
            .padding(.horizontal, 15)
            HStack(spacing: 0) {
                Text("Время начала встречи")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker(
                    selection: $store.meeting.start,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
                
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 20)
            
            HStack(spacing: 0) {
                Text("Время конца встречи")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker(
                    selection: $store.meeting.end,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 10)
            
            if store.isON {
                
                Text(store.timeString)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .gradientForeground(colors: [.pink, .purple])
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 16).stroke(.pink.opacity(0.5), lineWidth: 3)
                    }
                    .padding(.top, 15)
                
                
            } else {
                
                Text(store.timeString)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .gradientForeground(colors: [.pink, .purple])
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 16).stroke(.pink.opacity(0.5), lineWidth: 3)
                    }
                    .padding(.top, 15)
                    .hidden()
                
            }
            
            Spacer()
            SYButton(title: store.isON ? "Редактировать" : "Продолжить") {
                store.send(.continueButtonTapped)
            }.disabled(store.isButtonDisabled)
            
                .padding(.top, 20)
            
        }
        .padding(.horizontal, 24)
//        .task {
//            store.send(.startTimer)
//        }
        .alert(store.state.error.description, isPresented: $store.state.showError) {
            Button("OK", role: .cancel) { }
        }
        
    }
}
//
//#Preview {
//    RandomCoffeeView(
//        store: Store(initialState: RandomCoffeeFeature.State(), reducer: {
//            RandomCoffeeFeature()._printChanges()
//        })
//    )
//}
