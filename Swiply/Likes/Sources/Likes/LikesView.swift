import SwiftUI
import SYVisualKit
import CardInformation
import ProfilesService
import ComposableArchitecture

public struct LikesView: View {

    @Bindable var store: StoreOf<LikesFeature>

    @State private var data: [Person] =
    [
        Person.ann,
        Person.daria,
        Person.kate,
        Person.maria,
        Person.vera,
    ]

    public init(store: StoreOf<LikesFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()

                    Image(.logo)
                        .padding(.top, 10)

                    Spacer()
                }
                .padding(.bottom, 16)

                ZStack(alignment: .bottom) {
                    ScrollView {
                        if !data.isEmpty {
                            ForEach(Array(stride(from: 0, to: data.count - 1, by: 2)), id: \.self) { index in
                                if data.indices.contains(index + 1) {
                                    row(firstCard: data[index], secondCard: data[index + 1])
                                        .padding(.vertical, 2)
                                }
                            }
                        }

                        if data.count % 2 != 0 {
                            row(firstCard: data[data.count - 1])
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .scrollIndicators(.hidden)

                    SYButton(title: "Узнай, кто тебя лайкнул") {
                        store.send(.buyTapped)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    @ViewBuilder
    private func row(firstCard: Person, secondCard: Person? = nil) -> some View {
        if let secondCard {
            HStack(spacing: 12) {
                LikesCardView(person: firstCard, isBlured: !store.hasSubscription) {
                    removePersonWithId(firstCard.id)
                }
                    .frame(width: 156, height: 200)

                LikesCardView(person: secondCard, isBlured: !store.hasSubscription) {
                    removePersonWithId(secondCard.id)
                }
                    .frame(width: 156, height: 200)
            }
        }
        else {
            HStack(spacing: 12) {
                LikesCardView(person: firstCard, isBlured: !store.hasSubscription) {
                    removePersonWithId(firstCard.id)
                }
                    .frame(width: 156, height: 200)

                LikesCardView(person: firstCard, isBlured: !store.hasSubscription) {
                    removePersonWithId(firstCard.id)
                }
                    .frame(width: 156, height: 200)
                    .opacity(0)
            }
        }
    }

    private func removePersonWithId(_ id: UUID) {
        let index = data.firstIndex(where: { $0.id == id })
        if let index {
            print(index)
            data.remove(at: index)
        }
    }


}

//#Preview {
//    LikesView()
//}
