import Foundation
import SYCore

extension ServerUserProfile {

    var toProfile: Profile {
        Profile(
            id: UUID(uuidString: self.id) ?? UUID(),
            name: self.name,
            age: 22,
            gender: .male,
            interests: self.interests.map { $0.id },
            town: "Moscow",
            description: self.info,
            images: .init()
        )
    }

}
