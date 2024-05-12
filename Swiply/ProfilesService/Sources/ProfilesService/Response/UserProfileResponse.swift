import Foundation

// MARK: - UserProfileResponse

public struct UserProfileResponse: Codable {
    let userProfile: ServerUserProfile
}

// MARK: - UserProfile

public struct ServerUserProfile: Codable {
    let id, email, name: String
    let interests: [InterestResponse]
    let birthDay: Date
    let gender, info, subscriptionType: String
    let location: LocationResponse
}

// MARK: - Interest

public struct InterestResponse: Codable {
    let id, definition: String
}

// MARK: - Location

public struct LocationResponse: Codable {
    let lat, long: Int
}
