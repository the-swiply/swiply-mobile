import SwiftUI
import SYVisualKit
import ComposableArchitecture
import CardInformation
import ProfilesService

public struct RecommendationsView: View {

    @Bindable var store: StoreOf<Recommendations>

    @State private var data: [Person] =
    [
        Person.daria,
        Person.kate,
        Person.maria,
        Person.vera,
        Person.ann
    ]

//    @State var initialCards: [CardView] = [
//        CardView(
//            person: Person.daria.toCardPerson,
//            likeHandler: {
//                store.send(.likeButtonTapped)
//            },
//            dislikeHandler: store.send(.dislikeButtonTapped),
//            onTapCenter: store.send(.onTapCenter)
//        )
//        CardView(index: 0, person: Person.daria.toCardPerson, navigateTo: { CardInformationView(person: Person.daria) }),
//        CardView(index: 1, person: Person.kate.toCardPerson, navigateTo: { CardInformationView(person: Person.kate) }),
//        CardView(index: 2, person: Person.maria.toCardPerson, navigateTo: { CardInformationView(person: Person.maria) }),
//        CardView(index: 3, person: Person.vera.toCardPerson, navigateTo: { CardInformationView(person: Person.vera) }),
//        CardView(index: 4, person: Person.ann.toCardPerson, navigateTo: { CardInformationView(person: Person.ann) })
//    ]
//
//    @State var cards: [CardView] = [
//        CardView(index: 0, person: Person.daria.toCardPerson, navigateTo: { CardInformationView(person: Person.daria) }),
//        CardView(index: 1, person: Person.kate.toCardPerson, navigateTo: { CardInformationView(person: Person.kate) }),
//        CardView(index: 2, person: Person.maria.toCardPerson, navigateTo: { CardInformationView(person: Person.maria) }),
//        CardView(index: 3, person: Person.vera.toCardPerson, navigateTo: { CardInformationView(person: Person.vera) }),
//        CardView(index: 4, person: Person.ann.toCardPerson, navigateTo: { CardInformationView(person: Person.ann) })
//    ]

    @State var value: Double = 30

    public init(store: StoreOf<Recommendations>) {
        self.store = store
    }

    // MARK: - View

    public var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    MainBarView(onBack: {
                        store.send(.backButtonTapped)
                    },
                    onOptions:  { /*cards = initialCards.filter( { $0.person.age < Int(value) }) */}, value: $value)

                    Spacer()

                    VStack {
                        ZStack {
                            ForEach(data, id: \.id) { person in
                                SwipableView(swipeAction: store.state.swipeAction, id: person.id.uuidString) {
                                    CardView(
                                        person: person.toCardPerson,
                                        likeHandler: { store.send(.likeButtonTapped) },
                                        dislikeHandler: { store.send(.dislikeButtonTapped) },
                                        onTapCenter: { store.send(.onTapCenter) }
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)

                Rectangle()
                    .frame(height: 90)
                    .foregroundStyle(.background)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .onAppear() {
            store.send(.onAppear)
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
                .foregroundStyle(.pink)
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
