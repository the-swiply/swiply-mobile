import SwiftUI

public struct Person: Identifiable, Equatable {
    public let id = UUID()
    public var name: String
    public let age: Int
    public let gender: Gender
    public var interests: [String]
    public var town: String
    public var description: String
    public var images: [UIImage?]
}

public enum Gender {
    case male
    case female
    case none
    
    public var name: String {
        switch self {
        case .male:
            return "Мужской"
        case .female:
            return "Женский"
        case .none:
            return ""
        }
    }
}

public extension Person {
    static let jungkook = Person(
        name: "Jungkook", 
        age: 26,
        gender: .male,
        interests: [],
        town: "Seoul",
        description: "Lol по выол с ыолс лы тыол тытолы тоывл лытщыт ытлоы",
        images: [UIImage(resource: .jungkook)]
    )
   
    static let suga = Person(
        name: "Suga",
        age: 26,
        gender: .male,
        interests: [],
        town: "Seoul",
        description: "Lol",
        images: [UIImage(resource: .suga)]
    )

    static let ui = Person(
        name: "UI",
        age: 26,
        gender: .female,
        interests: [],
        town: "Seoul",
        description: "Lol",
        images: [UIImage(resource: .ui)]
    )
    

    static let te = Person(
        name: "Te",
        age: 26,
        gender: .male,
        interests: [],
        town: "Seoul",
        description: "Lol",
        images: [UIImage(resource: .techen)]
    )
    
 
    static let jimin = Person(
        name: "Jimin",
        age: 26,
        gender: .male,
        interests: [],
        town: "Seoul",
        description: "Lol",
        images: [UIImage(resource: .jimin)]
    )
}
