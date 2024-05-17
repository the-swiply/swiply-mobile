import SwiftUI

public struct CardPerson: Identifiable, Equatable {
    public let id = UUID()
    public var name: String
    public let age: Int
    public var interests: [String]
    public var town: String
    public var description: String
    public var images: [CardLoadableImage]

    public init(name: String, age: Int, interests: [String], town: String, description: String, images: [CardLoadableImage]) {
        self.name = name
        self.age = age
        self.interests = interests
        self.town = town
        self.description = description
        self.images = images
    }
}

public enum CardLoadableImage: Equatable {
    case image(Image)
    case loading
}

public struct CardView: View {

    let likeHandler: () -> Void
    let dislikeHandler: () -> Void
    let onTapCenter: () -> Void
    let info: [(Image, String)]

    var person: CardPerson

    public init(person: CardPerson, likeHandler: @escaping () -> Void, dislikeHandler: @escaping () -> Void, onTapCenter: @escaping () -> Void, info: [(Image, String)]) {
        self.likeHandler = likeHandler
        self.dislikeHandler = dislikeHandler
        self.onTapCenter = onTapCenter
        self.person = person
        self.info = info
    }

    public var body: some View {
        ZStack {
            ImageScrollingView(images: person.images, onTapCenter: onTapCenter)
                .overlay(alignment: .bottomLeading) {
                    BiographyOverlay(person: person, likeHandler: likeHandler, dislikeHandler: dislikeHandler, info: info)
                }
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

}
