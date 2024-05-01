import SwiftUI
import SYVisualKit
import CardInformation
import UserService

public struct LikesView: View {

    @State private var data: [Person] =
    [
        UserService.Person.ann,
        UserService.Person.daria,
        UserService.Person.kate,
        UserService.Person.maria,
        UserService.Person.vera,
    ]

    public init() { }

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
            }
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    private func row(firstCard: Person, secondCard: Person? = nil) -> some View {
        if let secondCard {
            HStack(spacing: 12) {
                LikesCardView(person: firstCard) {
                    removePersonWithId(firstCard.id)
                }
                    .frame(width: 156, height: 200)

                LikesCardView(person: secondCard) {
                    removePersonWithId(secondCard.id)
                }
                    .frame(width: 156, height: 200)
            }
        }
        else {
            HStack(spacing: 12) {
                LikesCardView(person: firstCard) {
                    removePersonWithId(firstCard.id)
                }
                    .frame(width: 156, height: 200)

                LikesCardView(person: firstCard) {
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

#Preview {
    LikesView()
}
