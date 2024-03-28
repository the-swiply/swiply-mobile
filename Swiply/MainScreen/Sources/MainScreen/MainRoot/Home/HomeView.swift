import SwiftUI
import ComposableArchitecture
import Authorization
import RandomCoffee

struct HomeView: View {

    @Bindable var store: StoreOf<Home>

    // MARK: - View

    var body: some View {
        if store.destination == nil {
            NavigationStack {
                VStack {
                    Image(.logo)
                        .padding(.top, 10)


                    HStack {
                        Text("Главная")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Spacer()
                    }
                    .padding(.all, 30)

                    Button {

                    } label: {
                        HStack {
                            Text("Подтвердить корпоративную почту")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)

                            Spacer()

                            Image(.email)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.pink)
                                .frame(width: 40)
                        }
                        .padding(.all, 24)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.white)
                                .shadow(radius: 8)
                        }
                        .padding(.bottom, 8)
                        .padding(.horizontal, 24)
                    }


                    Button {
                        store.send(.skipWelcome)
                    } label: {
                        HStack {
                            Text("Random \nCoffee")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.leading)

                            Spacer()

                            Image(.coffee)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.pink)
                                .frame(width: 40)
                        }
                        .padding(.all, 24)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.white)
                                .shadow(radius: 8)
                        }
                        .padding(.horizontal, 24)
                    }

                    Spacer()
                }
            }
        }
        IfLetStore(store.scope(state: \.destination?.emailConformation, action: \.destination.emailConformation)) { store in
            AuthorizationRootView(store: store)
        }
        
        IfLetStore(store.scope(state: \.destination?.randomCoffee, action: \.destination.randomCoffee)) { store in
            RandomCoffeeView(store: store)
        }
    }

}

//#Preview {
//    HomeView(store: .init(initialState: Home.State(), reducer: Home()))
//}
