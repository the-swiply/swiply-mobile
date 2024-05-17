import Foundation

struct CreateEventResponse: Codable {
    let event_id: String
}

struct GetEventsResponse: Codable {
    let events: [NetworkingEvent]
}

struct GetUserMembershipEventsResponse: Codable {
    let events: [NetworkingEvent]
}

struct GetUserOwnEventsResponse: Codable {
    let events: [NetworkingEvent]
}

struct GetEventMembersResponse: Codable {
    let users_statuses: [UserStatus]
}

struct UserStatus: Codable {
    let user_id: String
    let status: String
}

struct NetworkingEvent: Codable {
    let event_id: String
    let title: String
    let description: String
    let photos: [String]
    let chat_id: String
    let date: String
}
