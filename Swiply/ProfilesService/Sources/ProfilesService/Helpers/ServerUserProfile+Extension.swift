import Foundation
import SYCore

extension ServerUserProfile {

    var toProfile: Profile {
        Profile(
            id: UUID(uuidString: self.id) ?? UUID(),
            name: self.name,
            age: 22,
            gender: .init(rawValue: self.gender) ?? .none,
            interests: self.interests.map { $0.id },
            town: "Moscow",
            description: self.info, 
            email: self.email,
            images: .init()
        )
    }

}
