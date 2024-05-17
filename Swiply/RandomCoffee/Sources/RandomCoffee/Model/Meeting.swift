import Foundation

// MARK: - Meeting

public struct Meeting: Decodable {
    public let id, ownerId, memberId: String
    public let start, end, createdAt: String
    public let organizationId: Int
    public let status: MeetingStatus
}

// MARK: - MeetingStatus

public enum MeetingStatus: String, Decodable {
    case scheduled = "SCHEDULED"
    case scheduling = "SCHEDULING"
    case inProgress = "AWAITING_SCHEDULE"
    case none = "MEETING_STATUS_UNSPECIFIED"
    
}

// MARK: - CreateMeeting

public struct CreateMeeting: Equatable {
    public let meetingId: String
    public var start, end: Date
    public var organizationId: Int
    
    public init(meetingId: String, start: Date, end: Date, organizationId: Int) {
        self.meetingId = meetingId
        self.start = start
        self.end = end
        self.organizationId = organizationId
    }
    
    public init() {
        self.start = Date()
        self.end = Date()
        self.organizationId = -1
        self.meetingId = ""
    }
}

// MARK: - Extension Meeting

public extension Meeting {
    
    func toCreateMeeting() -> CreateMeeting {
        .init(
            meetingId: self.id,
            start: DateFormatter.server.date(from: self.start) ?? Date(),
            end: DateFormatter.server.date(from: self.end) ?? Date(),
            organizationId: self.organizationId
        )
    }
}
