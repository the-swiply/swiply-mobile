import Foundation
import SYCore
// MARK: - UserProfileResponse

public struct UserProfileResponse: Codable {
    let userProfile: ServerUserProfile
    
    enum CodingKeys: String, CodingKey {
        case userProfile = "user_profile"
    }
}

// MARK: - UserProfile

public struct ServerUserProfile: Codable {
    let id, email, name: String
    let interests: [Interest]
    let birthDay, gender, info, subscriptionType: String
    let location: LocationResponse
    let city, work, education: String
    let isBlocked: Bool
    let organizations: [OrganizationResponse]
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, interests
        case birthDay = "birth_day"
        case gender, info
        case subscriptionType = "subscription_type"
        case location, city, work, education
        case isBlocked = "is_blocked"
        case organizations
    }
}

// MARK: - Location

public struct LocationResponse: Codable {
    let lat, long: Int
}

public struct OrganizationResponse: Codable {
    let id, organizationId: Int
    let name, email: String
    let is_valid: Bool
}

