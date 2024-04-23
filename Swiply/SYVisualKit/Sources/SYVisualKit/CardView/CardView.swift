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
    public var person: CardPerson
    var navigateTo: () -> V

    public init(index: Int, tagId: UUID = UUID(), person: CardPerson, navigateTo: @escaping () -> V) {
        self.index = index
        self.tagId = tagId
        self.person = person
        self.navigateTo = navigateTo
    }

    public var body: some View {
        ZStack {
            ImageScrollingView(images: person.images, onTapCenter: nil)
                .overlay(alignment: .bottomLeading) {
                    BiographyOverlay(person: person)
                }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            NavigationLink(
                destination: navigateTo(),
                label: {
                    Rectangle()
                        .frame(width: 50, height: 600)
                        .background(.clear)
                        .opacity(0)
                }
            )
        }
    }

}
