import SwiftUI
import SYVisualKit

public extension Profile {

    var cardPerson: CardPerson {
        .init(
            name: self.name,
            age: self.age.getAge(),
            interests: self.interests.map { $0.definition },
            town: self.town,
            description: self.description,
            images: self.images.images.map { $0.cardLoadableImage }
        )
    }

}

extension ImageState {

    var cardLoadableImage: CardLoadableImage {
        switch self {
        case .loading:
            return .loading

        case .image(let info):
            return .image(Image(uiImage: info.image))
        }
    }

}
