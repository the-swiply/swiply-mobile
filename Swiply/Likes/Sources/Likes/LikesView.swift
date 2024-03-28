import SwiftUI
import SYVisualKit

public struct LikesView: View {

    public struct LikesCardData {

        let image: Image
        let name: String
        let age: String

    }

    private var data: [LikesCardData] { [
        .init(image: Image(.girl1), name: "Вероника", age: "22"),
        .init(image: Image(.girl2), name: "Соня", age: "24"),
        .init(image: Image(.girl3), name: "Мария", age: "23"),
        .init(image: Image(.girl1), name: "Вероника", age: "22"),
        .init(image: Image(.girl2), name: "Соня", age: "24"),
        .init(image: Image(.girl3), name: "Мария", age: "23"),
        .init(image: Image(.girl1), name: "Вероника", age: "22"),
        .init(image: Image(.girl1), name: "Вероника", age: "22"),
        .init(image: Image(.girl2), name: "Соня", age: "24"),
        .init(image: Image(.girl3), name: "Мария", age: "23"),
        .init(image: Image(.girl1), name: "Вероника", age: "22"),
        .init(image: Image(.girl2), name: "Соня", age: "24"),
        .init(image: Image(.girl3), name: "Мария", age: "23"),
        .init(image: Image(.girl1), name: "Вероника", age: "22"),
        .init(image: Image(.girl1), name: "Вероника", age: "22")
    ]
    }

    public init() { }

    public var body: some View {
        VStack {
            HStack {
                Spacer()

                Image(.logo)

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
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private func row(firstCard: LikesCardData, secondCard: LikesCardData? = nil) -> some View {
        if let secondCard {
            HStack(spacing: 12) {
                LikesCardView(
                    image: firstCard.image,
                    name: firstCard.name,
                    age: firstCard.age
                )
                .frame(width: 180, height: 220)

                LikesCardView(
                    image: secondCard.image,
                    name: secondCard.name,
                    age: secondCard.age
                )
                .frame(width: 180, height: 220)
            }
        }
        else {
            HStack(spacing: 12) {
                LikesCardView(
                    image: firstCard.image,
                    name: firstCard.name,
                    age: firstCard.age
                )
                .frame(width: 180, height: 220)

                LikesCardView(
                    image: firstCard.image,
                    name: firstCard.name,
                    age: firstCard.age
                )
                .frame(width: 180, height: 220)
                .opacity(0)
            }
        }
    }

}

#Preview {
    LikesView()
}
