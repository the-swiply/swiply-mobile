import Foundation
import SYCore

struct CreateProfileRequest: Encodable {
    let email: String
    let name: String
    let birth_day: String
    let interests: [Interest]
    let gender: String
    let info: String
    let subscriptionType: String
    let city: String
    let work: String
    let education: String
    
    
    init(email: String, name: String, birth_day: String, interests: [Interest], gender: String, info: String, subscriptionType: String, city: String, work: String, education: String) {
        self.email = email
        self.name = name
        self.birth_day = birth_day
        self.interests = interests
        self.gender = gender
        self.info = info
        self.subscriptionType = subscriptionType
        self.city = city
        self.work = work
        self.education = education
    }
    
    
    init(_ profile: CreatedProfile) {
        self.email = profile.email
        self.name = profile.name
        self.birth_day = DateFormatter.server.string(from: profile.age)
        self.interests = profile.interests
        self.gender = profile.gender.rawValue
        self.info = profile.description
        self.subscriptionType = "STANDARD"
        self.city = profile.town
        self.work = profile.work
        self.education = profile.education
    }
}


struct UpdateProfileRequest: Encodable {
    let name: String
    let birth_day: String
    let interests: [Interest]
    let gender: String
    let info: String
    let subscriptionType: String
    let city: String
    let work: String
    let education: String
    
    init(name: String, birth_day: String, interests: [Interest], gender: String, info: String, subscriptionType: String, city: String, work: String, education: String) {
        self.name = name
        self.birth_day = birth_day
        self.interests = interests
        self.gender = gender
        self.info = info
        self.subscriptionType = subscriptionType
        self.city = city
        self.work = work
        self.education = education
    }
    
    init(_ profile: Profile) {
        self.name = profile.name
        self.birth_day = DateFormatter.server.string(from: profile.age)
        self.interests = profile.interests
        self.gender = profile.gender.rawValue
        self.info = profile.description
        self.subscriptionType = "STANDARD"
        self.city = profile.town
        self.work = profile.work
        self.education = profile.education
    }
}
