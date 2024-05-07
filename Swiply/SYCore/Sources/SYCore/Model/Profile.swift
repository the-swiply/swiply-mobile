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
    public var images: [ProfileImage]
}

// MARK: - Gender

public enum Gender {
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

// MARK: - ProfileImage

public class ProfileImage {

    var image: LoadableImage

    init(image: LoadableImage) {
        self.image = image
    }

}