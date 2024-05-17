import Foundation
import SYCore

extension ServerUserProfile {

    var toProfile: Profile {
        Profile(
            id:  UUID(uuidString: self.id) ?? UUID(), 
            name: self.name,
            age: DateFormatter.server.date(from: self.birthDay) ?? Date(),
            gender: .init(rawValue: self.gender) ?? .none,
            interests: self.interests,
            town: self.city,
            description: self.info,
            email: self.email,
            images: .init(),
            education: self.education,
            work: self.work, 
            corporateMail: []
        )
    }

}
