import SwiftUI
import ComposableArchitecture
import SYVisualKit

public struct RCInfoView: View {
    @Bindable var store: StoreOf<RCInfo>
    
    public init(store: StoreOf<RCInfo>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(.rcHeart)
                .resizable()
                .frame(width: 126, height: 158)
                .padding(.bottom, 3)
            
            Text("Random Coffee")
                .fontWeight(.semibold)
                .font(.title2)
                .gradientForeground(colors: [.pink, .purple])
                .padding(.bottom, 50)
            
            Text("Это практика случайных встреч между сотрудниками внутри организации за кофе брейком. Выбери удобное время и мы найдём тебе компанию на перерыв. Детали сможете обсудить в чате.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.bottom, 130)
            
            SYButton(title: "Понятно") {
                store.send(.continueButtonTapped)
            }.padding(.bottom, 60)
            
        }
        .padding(.horizontal, 24)
        .alert(store.state.error.description, isPresented: $store.state.showError) {
            Button("OK", role: .cancel) { }
        }
    }
}


#Preview {
    RCInfoView(
        store: Store(initialState: RCInfo.State(), reducer: {
            RCInfo()._printChanges()
        })
    )
}
