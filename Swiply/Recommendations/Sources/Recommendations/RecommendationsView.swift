import SwiftUI
import SYVisualKit
import ComposableArchitecture
import CardInformation
import UserService

public struct RecommendationsView: View {

//    @Bindable var store: StoreOf<Recommendations>

    @State var lastIndex = 0

    @State private var data: [Person] =
    [
        UserService.Person.daria,
        UserService.Person.kate,
        UserService.Person.maria,
        UserService.Person.vera,
        UserService.Person.ann
    ]

    @State var initialCards: [CardView] = [
        CardView(index: 0, person: UserService.Person.daria.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.daria) }),
        CardView(index: 1, person: UserService.Person.kate.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.kate) }),
        CardView(index: 2, person: UserService.Person.maria.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.maria) }),
        CardView(index: 3, person: UserService.Person.vera.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.vera) }),
        CardView(index: 4, person: UserService.Person.ann.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.ann) })
    ]

    @State var cards: [CardView] = [
        CardView(index: 0, person: UserService.Person.daria.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.daria) }),
        CardView(index: 1, person: UserService.Person.kate.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.kate) }),
        CardView(index: 2, person: UserService.Person.maria.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.maria) }),
        CardView(index: 3, person: UserService.Person.vera.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.vera) }),
        CardView(index: 4, person: UserService.Person.ann.toCardPerson, navigateTo: { CardInformationView(person: UserService.Person.ann) })
    ]

    @State var value: Double = 30

    public init() { }

    // MARK: - View

    public var body: some View {
        NavigationStack {
            VStack {
                MainBarView(onBack: { 
                    cards.append(.init(index: cards.count - 1, person: data[lastIndex].toCardPerson, navigateTo: { CardInformationView(person: data[lastIndex]) }))
                },
                            onOptions:  { cards = initialCards.filter( { $0.person.age < Int(value) }) }, value: $value)

                Spacer()

                ZStack {
                    ForEach(cards, id: \.person.id) { card in
                        SwipableView {
                            card
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

}

private struct MainBarView: View {

    var onBack: (() -> Void)?
    var onOptions: (() -> Void)?

    @State var isPresented: Bool = false
    @Binding var value: Double

    var body: some View {
        HStack {
            Button {
                onBack?()
            } label: {
                Image(.backArrow)
            }

            Spacer()


            Image(.mainBarLogo)
                .padding(.vertical, 10)

            Spacer()

            Button(
                action: {
                    isPresented = true
                },
                label: {
                    Image(.filter)
                }
            )
            .sheet(isPresented: $isPresented) {
                VStack {
                    Text("Фильтр")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 48)

                    Slider(value: $value,
                           in: 18...99,
                           step: 1,
                           minimumValueLabel: Text("18"),
                           maximumValueLabel: Text(Int(value).description),
                           label: {
                        Text("Возраст")
                    }
                    )
                    .padding(.bottom, 24)

                    SYButton(title: "Применить") {
                        onOptions?()
                    }
                }
                .padding(.horizontal, 24)
                .presentationDetents([.medium])
            }
        }
    }

}

extension Person {

    var toCardPerson: CardPerson {
        .init(name: name, age: age, interests: interests, town: town, description: description, images: images.map { Image(uiImage: $0!) })
    }

}


//#Preview {
//    RecommendationsView(
//        store: Store(initialState: Recommendations.State()) {
//            Recommendations()
//        }
//    )
//}
