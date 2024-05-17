import SwiftUI
import ComposableArchitecture
import SYVisualKit

struct PaywallView: View {

    @Bindable var store: StoreOf<PaywallFeature>

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()

                Image(.swiplyPremium)
                    .padding(.top, 10)

                Spacer()

                Image(systemName: "xmark")
                    .padding(.trailing, 24)
                    .padding(.top, 10)
            }
            .padding(.bottom, 56)
            .padding(.leading, 24)

            VStack {
                Image(.likes)
                    .padding(.bottom, 16)

                Text("Узнайте, кто вас лайкнул!")
                    .foregroundStyle(.pink)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 16)


                Text("Получи все преимущества Premium и дополнительные сверхспособности.")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.regular)
            }
            .padding(.horizontal, 50)

            Spacer()

            HStack(spacing: 10) {
                SubscriptionOptionView(number: "1", title: "месяц", price: "499 ₽", isSelected: true)

                SubscriptionOptionView(number: "3", title: "месяца", price: "1290 ₽", isSelected: false)

                SubscriptionOptionView(number: "1", title: "год", price: "3990 ₽", isSelected: false)
            }
            .padding(.bottom, 24)


            SYButton(title: "Продолжить") {
                store.send(.tapped)
            }.padding(.all, 24)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }

}

struct SubscriptionOptionView: View {

    let number: String
    let title: String
    let price: String
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(width: 105, height: 185)
            .foregroundStyle(isSelected ? .pink : .white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .clear : .pink, lineWidth: 3)
            )
            .overlay {
                VStack {
                    HStack {
                        Spacer()

                        Image(.subscriptionLogo)
                            .foregroundStyle(isSelected ? .white : .pink)
                    }
                    .padding(.trailing, 10)
                    .padding(.bottom, 16)

                    Text(number)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(isSelected ? .white : .pink)

                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : .pink)
                        .padding(.bottom, 16)

                    Text(price)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : .pink)
                }
            }
            .padding(.bottom, 16)
    }

}

//#Preview {
//    PaywallView()
//}
