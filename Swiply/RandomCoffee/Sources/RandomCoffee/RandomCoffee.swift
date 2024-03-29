import SwiftUI
import ComposableArchitecture
import SYVisualKit

@Reducer
public struct RandomCoffeeFeature {
    
    @ObservableState
    public struct State: Equatable {
        var selectedDate = Date()
        var startTime = Date()
        var endTime = Date()
        var town = ""
        
        public init() {}
    }
    @Dependency(\.dismiss) var dismiss
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case continueButtonTapped
        case dismiss
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .run { _ in
                    await self.dismiss()
                }
            case .binding:
                return .none
            case .continueButtonTapped:
                return .none
            }
        }
    }
    
    public init() {}
}

public struct RandomCoffeeView: View {
    
    @Bindable var store: StoreOf<RandomCoffeeFeature>
    
    public init(store: StoreOf<RandomCoffeeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Image(systemName: "trash")
                .onTapGesture {
                    store.send(.dismiss)
                }
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
                
            }
            .padding(.top, 30)
            HStack(spacing: 0) {
                Text("Время начала встречи")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker(
                    selection: $store.startTime,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
                
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 30)
            
            HStack(spacing: 0) {
                Text("Время конца встречи")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                DatePicker(
                    selection: $store.endTime,
                    displayedComponents: [.hourAndMinute], label: {
                        
                    })
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale.init(identifier: "ru"))
            }
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 10)
            
            VStack(alignment: .leading) {
                
                TextField("Город встречи", text: $store.town)
                    .padding(15)
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.top, 30)
            
            Spacer()
            SYButton(title: "Продолжить") {
                store.send(.continueButtonTapped)
            }
            .padding(.bottom, 50)
            
        }
        
        .padding(.horizontal, 24)
        
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
