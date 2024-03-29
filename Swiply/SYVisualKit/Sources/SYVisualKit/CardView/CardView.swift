import SwiftUI

public struct CardPerson: Identifiable, Equatable {
    public let id = UUID()
    public var name: String
    public let age: Int
    public var interests: [String]
    public var town: String
    public var description: String
    public var images: [Image]

    public init(name: String, age: Int, interests: [String], town: String, description: String, images: [Image]) {
        self.name = name
        self.age = age
        self.interests = interests
        self.town = town
        self.description = description
        self.images = images
    }
}

public struct CardView<V: View>: View {

    var info: [(Image, String)] {
        [(Image(.heart), "Отношения") ,(Image(.ruler), "172") ,(Image(.pets), "Нет") ,(Image(.aquarius), "Водолей") ,(Image(.study), "Высшее")]
    }

    @State var flowSize: CGSize = .zero

    var index: Int
    var tagId: UUID
    var person: CardPerson
    var navigateTo: () -> V

    public init(index: Int, tagId: UUID = UUID(), person: CardPerson, navigateTo: @escaping () -> V) {
        self.index = index
        self.tagId = tagId
        self.person = person
        self.navigateTo = navigateTo
    }

    public var body: some View {
        ZStack {
            PhotosView(images: person.images)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(person.name), \(person.age)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        HStack(spacing: 8) {
                            Image(.homeCardIcon)

                            Text(person.town)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 12)

                        SYFlowView(
                            content: info.map {
                                SYBlurChip(text: $0.1, image: $0.0)
                            }
                        )

                        HStack {
                            Button {

                            } label: {
                                Image(.dislike)
                            }

                            Spacer()

                            Button {

                            } label: {
                                Image(.like)
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(.bottom, 35)
                    .padding(.horizontal, 16)
                }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            NavigationLink(
                destination: navigateTo(),
                label: {
                    Rectangle()
                        .frame(width: 90, height: 600)
                        .background(.clear)
                        .opacity(0)
                }
            )
        }
    }

}
