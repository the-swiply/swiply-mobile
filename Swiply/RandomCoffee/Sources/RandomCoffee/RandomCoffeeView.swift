import SwiftUI
import ComposableArchitecture
import SYVisualKit

public struct RandomCoffeeView: View {
    
    @Bindable var store: StoreOf<RandomCoffeeFeature>
    
    public init(store: StoreOf<RandomCoffeeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            
//            HStack(alignment: .center) {
//                Image(.randomCoffee)
//                    .resizable()
//                    .frame(width: 50, height: 40)
//                
//                Text("Random Coffee")
//                    .padding(.leading)
//                    .fontWeight(.semibold)
//                    .font(.title3)
//                    .gradientForeground(colors: [.pink, .purple])
//            }
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
//            VStack(alignment: .center) {
                Text("Выберите удобное время для встречи завтра. А мы найдём вам компанию с вашей работы или института.")
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding()
                   
//            }
           
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text("Город")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                SYTextField(
                    placeholder: "Введите свой город",
                    footerText: "",
                    text: $store.town
                )
             
            }
//            .padding(.bottom, 50)
            
            HStack(spacing: 0) {
                Text("Начало встречи:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                DatePicker(
                    selection: $store.startTime,
                    displayedComponents: [.hourAndMinute], label: {
                    })
                
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
//                .colorInvert()
                
            }
            .padding()
//            .background(.pink.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 20)
//            
            HStack(spacing: 0) {
                Text("Время конца встречи")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                DatePicker(
                    selection: $store.endTime,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
//                .colorInvert()

//                .foregroundStyle(.ultraThickMaterial)
//                .colorMultiply(.white)
//                .background()
            }
            .padding()
//            .background(.pink.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 10)
//            
//            if store.isON {
//                
//                Text(store.timeString)
//                    .fontWeight(.semibold)
//                    .font(.title3)
//                    .gradientForeground(colors: [.pink, .purple])
//                    .padding()
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 16).stroke(.pink.opacity(0.5), lineWidth: 3)
//                    }
//                    .padding(.top, 15)
//                
//                    
//            } else {
//                
//                Text("store.timeString")
//                    .fontWeight(.semibold)
//                    .font(.title3)
//                    .gradientForeground(colors: [.pink, .purple])
//                    .padding()
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 16).stroke(.pink.opacity(0.5), lineWidth: 3)
//                    }
//                    .padding(.top, 15)
//                    .hidden()
//                    
//            }
//            
            Spacer()
            SYButton(title: "Назначить встречу") {
                store.send(.continueButtonTapped)
            }.disabled(store.isButtonDisabled)
            
            .padding(.bottom, 60)
            
        }
        .padding(.horizontal, 24)
        .task {
            store.send(.startTimer)
        }

    }
}

#Preview {
    RandomCoffeeView(
        store: Store(initialState: RandomCoffeeFeature.State(), reducer: {
            RandomCoffeeFeature()._printChanges()
        })
    )
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        )
        .mask(self)
    }
}
