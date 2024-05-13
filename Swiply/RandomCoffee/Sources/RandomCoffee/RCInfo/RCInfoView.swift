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
            Image(.randomCoffee)
                .resizable()
                .frame(width: 126, height: 158)
                .padding(.bottom, 3)
            
            Text("Random Coffee")
                .fontWeight(.semibold)
                .font(.title2)
                .gradientForeground(colors: [.pink, .purple])
                .padding(.bottom, 80)
            
            Text("do,dnv jnv  jndj sk")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.bottom, 130)
//            Spacer()
            
            SYButton(title: "Понятно") {
                store.send(.continueButtonTapped)
            }.padding(.bottom, 60)
            
        }
        .padding(.horizontal, 24)
    }
}


#Preview {
    RCInfoView(
        store: Store(initialState: RCInfo.State(), reducer: {
            RCInfo()._printChanges()
        })
    )
}
