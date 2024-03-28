import SwiftUI
import SYVisualKit
import CardInformation

public struct LikesView: View {

    public struct LikesCardData {

        let image: Image
        let name: String
        let age: String

    }

    private var data: [LikesCardData] {
        [
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
    private func row(firstCard: LikesCardData, secondCard: LikesCardData? = nil) -> some View {
        if let secondCard {
            HStack(spacing: 12) {
                NavigationLink(
                    destination: CardInformationView(),
                    label: {
                        LikesCardView(
                            image: firstCard.image,
                            name: firstCard.name,
                            age: firstCard.age
                        )
                        .frame(width: 156, height: 200)
                    }
                )

                NavigationLink(
                    destination: CardInformationView(),
                    label: {
                        LikesCardView(
                            image: secondCard.image,
                            name: secondCard.name,
                            age: secondCard.age
                        )
                        .frame(width: 156, height: 200)
                    }
                    )
            }
        }
        else {
            HStack(spacing: 12) {
                NavigationLink(
                    destination: CardInformationView(),
                    label: {
                        LikesCardView(
                            image: firstCard.image,
                            name: firstCard.name,
                            age: firstCard.age
                        )
                        .frame(width: 156, height: 200)
                    }
                    )

                LikesCardView(
                    image: firstCard.image,
                    name: firstCard.name,
                    age: firstCard.age
                )
                .frame(width: 156, height: 200)
                .opacity(0)
            }
        }
    }


}

#Preview {
    LikesView()
}
