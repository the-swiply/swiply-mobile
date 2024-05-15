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

public struct CardView: View {

    let likeHandler: () -> Void
    let dislikeHandler: () -> Void
    let onTapCenter: () -> Void

    var person: CardPerson

    public init(person: CardPerson, likeHandler: @escaping () -> Void, dislikeHandler: @escaping () -> Void, onTapCenter: @escaping () -> Void) {
        self.likeHandler = likeHandler
        self.dislikeHandler = dislikeHandler
        self.onTapCenter = onTapCenter
        self.person = person
    }

    public var body: some View {
        ZStack {
            ImageScrollingView(images: person.images, onTapCenter: onTapCenter)
                .overlay(alignment: .bottomLeading) {
                    BiographyOverlay(person: person, likeHandler: likeHandler, dislikeHandler: dislikeHandler)
                }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

}
