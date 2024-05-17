import SwiftUI

// MARK: - Profile

public struct Profile: Equatable {
    public let id: UUID
    public var name: String
    public let age: Date
    public let email: String
    public let gender: Gender
    public var interests: [Interest]
    public var town: String
    public var description: String
    public var images: LoadableImageCollection
    public var education: String
    public var work: String
    public let corporateMail: [UserOrganization]

    public init(id: UUID,
                name: String,
                age: Date,
                gender: Gender,
                interests: [Interest],
                town: String,
                description: String,
                email: String,
                images: LoadableImageCollection,
                education: String,
                work: String,
                corporateMail: [UserOrganization]) {
        
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.interests = interests
        self.town = town
        self.description = description
        self.email = email
        self.images = images
        self.education = education
        self.work = work
        self.corporateMail = corporateMail
    }
    
    public init() {
        self.id = UUID()
        self.name = ""
        self.age = Date()
        self.gender = .none
        self.interests = []
        self.town = ""
        self.description = ""
        self.email = ""
        self.images = .init()
        self.education = ""
        self.work = ""
        self.corporateMail = []
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
}

// MARK: - LoadableImageCollection

@Observable
public class LoadableImageCollection: Equatable {

    public var images: [ImageState]
    public var task: Task<Void, Never>?

    public init(images: [ImageState] = [.loading]) {
        self.images = images
    }

    public static func == (lhs: LoadableImageCollection, rhs: LoadableImageCollection) -> Bool {
        lhs.images == rhs.images
    }
    
    public func getFirstImage() -> UIImage {
        var firstImage: UIImage?
        self.images.forEach { image in
            switch image {
            case .loading:
                break
            case let .image(uIImage):
                firstImage = uIImage
            }
        }
        
        return firstImage ?? UIImage(resource: .noPhoto)
    }
}

// MARK: - Interest

public struct Interest: Codable, Hashable {
    public let id: String
    public let definition: String
}


public struct UserOrganization: Codable, Hashable {
    public let id, organization_id : Int
    public let name, email: String
    public let is_valid: Bool
}
