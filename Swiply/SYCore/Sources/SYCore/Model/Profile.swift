import SwiftUI

// MARK: - Profile

public struct Profile {
    public let id: UUID
    public var name: String
    public let age: Int
    public let gender: Gender
    public var interests: [String]
    public var town: String
    public var description: String
    public var images: [LoadableImage]
}

// MARK: - Gender

public enum Gender: Codable {
    case male
    case female
    case none

    public var name: String {
        switch self {
        case .male:
            "Мужской"

        case .female:
            "Женский"

        case .none:
            ""
        }
    }
}

// MARK: - LoadableImage

public class LoadableImage {

    var image: ImageState

    init(image: ImageState) {
        self.image = image
    }

}
