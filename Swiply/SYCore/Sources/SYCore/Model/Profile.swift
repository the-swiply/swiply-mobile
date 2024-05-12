import SwiftUI

// MARK: - Profile

public struct Profile {
    public let id: UUID
    public var name: String
    public let age: Int
    public let email: String
    public let gender: Gender
    public var interests: [String]
    public var town: String
    public var description: String
    public var images: LoadableImageCollection

    public init(id: UUID,
                name: String,
                age: Int,
                gender: Gender,
                interests: [String],
                town: String,
                description: String,
                email: String,
                images: LoadableImageCollection){
        
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.interests = interests
        self.town = town
        self.description = description
        self.email = email
        self.images = images
    }
}

// MARK: - Gender

public enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
    case none = "GENDER_UNSPECIFIED"

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
    
//    public var code: Int {
//        switch self {
//        case .male:
//            1
//        case .female:
//            2
//        case .none:
//            0
//        }
//    }
}

// MARK: - LoadableImageCollection

@Observable
public class LoadableImageCollection {

    public var images: [ImageState]
    public var task: Task<Void, Never>?

    public init(images: [ImageState] = [.loading]) {
        self.images = images
    }

}
