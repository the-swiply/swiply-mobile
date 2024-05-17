import SwiftUI
import ComposableArchitecture
import Authorization
import RandomCoffee
import Events

struct HomeView: View {

    @Bindable var store: StoreOf<Home>

    // MARK: - View

    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            VStack {
                Image(.logo)
                    .padding(.top, 10)
                    .padding(.bottom, 16)

                HStack {
                    Text("Главная")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)

                Button {
                    store.send(.emailConfirmationTapped)
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
                    .frame(height: 100)
                    .padding(.all, 24)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)
                }


                Button {
                    store.send(.randomCoffeeTapped)
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
                    .frame(height: 100)
                    .padding(.all, 24)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 24)
                }

                Button {
                    store.send(.eventsTapped)
                } label: {
                    HStack {
                        Text("Мероприятия")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(.events)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.pink)
                            .frame(width: 40)
                    }
                    .frame(height: 100)
                    .padding(.all, 24)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        } destination: { store in
            switch store.case {
            case let .emailConformation(store):
                EmailInputView(store: store)

            case let .otp(store):
                OTPView(store: store)

            case let .randomCoffee(store):
                RandomCoffeeView(store: store)

            case let .events(store):
                EventsView(store: store)

            case let .eventCreation(store):
                AddEventView()

            case let .randomCoffeeInfo(store):
                RCInfoView(store: store)
            }
        }
    }

}

//#Preview {
//    HomeView(store: .init(initialState: Home.State(), reducer: Home()))
//}
