import Foundation
import Dependencies
import Networking
import SYCore

// MARK: - EventsNetworking

protocol EventsNetworking {

    func create(event: Event) async -> Result<CreateEventResponse, RequestError>
    func joinEvent(id: UUID) async -> Result<EmptyResponse, RequestError>
    func eventMembers(id: UUID) async -> Result<GetEventMembersResponse, RequestError>
    func updateEvent(info: Event) async -> Result<EmptyResponse, RequestError>
    func getEvents() async -> Result<GetEventsResponse, RequestError>
    func acceptUser(eventId: UUID, userId: UUID) async -> Result<EmptyResponse, RequestError>
    func myEvents() async -> Result<GetUserOwnEventsResponse, RequestError>
    func membership() async -> Result<GetUserMembershipEventsResponse, RequestError>

}

// MARK: - DependencyKey

enum EventsNetworkingKey: DependencyKey {

    public static var liveValue: any EventsNetworking = LiveEventsNetworking()

}

// MARK: - DependencyValues

extension DependencyValues {

    var eventsNetworking: any EventsNetworking {
        get { self[EventsNetworkingKey.self] }
        set { self[EventsNetworkingKey.self] = newValue }
    }

}


// MARK: - LiveEventsNetworking

class LiveEventsNetworking: LiveTokenUpdatableClient, EventsNetworking {

    func create(event: Event) async -> Result<CreateEventResponse, RequestError> {
        await sendRequest(.create(event: event))
    }

    func joinEvent(id: UUID) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.joinEvent(id: id))
    }

    func eventMembers(id: UUID) async -> Result<GetEventMembersResponse, RequestError> {
        await sendRequest(.eventMembers(id: id))
    }

    func updateEvent(info: Event) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.updateEvent(info: info))
    }

    func getEvents() async -> Result<GetEventsResponse, RequestError> {
        await sendRequest(.getEvents())
    }

    func acceptUser(eventId: UUID, userId: UUID) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.acceptUser(eventId: eventId, userId: userId))
    }

    func myEvents() async -> Result<GetUserOwnEventsResponse, RequestError> {
        await sendRequest(.myEvents())
    }

    func membership() async -> Result<GetUserMembershipEventsResponse, RequestError> {
        await sendRequest(.membership)
    }

}

// MARK: - Endpoint

enum EventsNetworkingEndpoint: TokenizedEndpoint {

    case create(event: Event)
    case joinEvent(id: UUID)
    case eventMembers(id: UUID)
    case updateEvent(info: Event)
    case getEvents
    case acceptUser(eventId: UUID, userId: UUID)
    case myEvents
    case membership

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "event"
    }


    var path: String {
        switch self {
        case .create:
            "v1/event/create"

        case .joinEvent:
            "v1/event/join"

        case .eventMembers:
            "v1/event/members"

        case .updateEvent:
            "v1/event/update"

        case .getEvents:
            "v1/events"

        case .acceptUser:
            "v1/event/accept-join"

        case .myEvents:
            "v1/events/my"

        case .membership:
            "v1/event/membership"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .create, .acceptUser, .updateEvent, .joinEvent:
                .post

        case .membership, .myEvents, .getEvents, .eventMembers:
                .get
        }
    }

    var body: [String : Codable]? {
        switch self {
        case .create(event: let event):
            return [
                "id": event.id,
                "title": event.name,
                "description": event.description,
                "photos": "\(event.images.map { $0.jpegData(compressionQuality: 0) })",
                "date": event.date.timeIntervalSince1970.description
            ]

        case .membership, .myEvents, .getEvents, .eventMembers, .joinEvent:
            return [:]

        case .updateEvent(info: let info):
            return [
                "id": info.id,
                "title": info.name,
                "description": info.description,
                "photos": "\(info.images.map { $0.jpegData(compressionQuality: 0) })",
                "date": info.date.timeIntervalSince1970.description
            ]

        case .acceptUser(eventId: let eventId, userId: let userId):
            return [
                "event": eventId.uuidString.lowercased(),
                "userId": userId.uuidString.lowercased()
            ]
        }
    }

    #if DEBUG

    var port: Int? {
        18084
    }

    #endif

}

// MARK: - Extension Request

private extension Request {

    static var membership: Self {
        .init(requestTimeout: .infinite, endpoint: EventsNetworkingEndpoint.membership)
    }

    static func create(event: Event) -> Self {
        .init(endpoint: EventsNetworkingEndpoint.create(event: event))
    }

    static func joinEvent(id: UUID) -> Self {
        .init(endpoint: EventsNetworkingEndpoint.joinEvent(id: id))
    }

    static func eventMembers(id: UUID) -> Self {
        .init(requestTimeout: .infinite, endpoint: EventsNetworkingEndpoint.eventMembers(id: id))
    }

    static func updateEvent(info: Event) -> Self {
        .init(endpoint: EventsNetworkingEndpoint.updateEvent(info: info))
    }

    static func getEvents() -> Self {
        .init(requestTimeout: .infinite, endpoint: EventsNetworkingEndpoint.getEvents)
    }

    static func acceptUser(eventId: UUID, userId: UUID) -> Self {
        .init(endpoint: EventsNetworkingEndpoint.acceptUser(eventId: eventId, userId: userId))
    }

    static func myEvents() -> Self {
        .init(requestTimeout: .infinite, endpoint: EventsNetworkingEndpoint.myEvents)
    }

}

