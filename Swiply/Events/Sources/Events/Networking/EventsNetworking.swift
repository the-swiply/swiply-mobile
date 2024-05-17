import Foundation
import Dependencies
import Networking
import SYCore

// MARK: - EventsNetworking

protocol EventsNetworking {

    func create(event: Event) async -> Result<EmptyResponse, RequestError>
    func joinEvent(id: UUID) async -> Result<EmptyResponse, RequestError>
    func eventMembers(id: UUID) async -> Result<EmptyResponse, RequestError>
    func updateEvent(info: Event) async -> Result<EmptyResponse, RequestError>
    func getEvents() async -> Result<EmptyResponse, RequestError>
    func acceptUser(eventId: UUID, userId: UUID) async -> Result<EmptyResponse, RequestError>
    func myEvents() async -> Result<EmptyResponse, RequestError>
    func membership(number: Int) async -> Result<EmptyResponse, RequestError>

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

    func create(event: Event) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.create(event: event))
    }

    func joinEvent(id: UUID) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.joinEvent(id: id))
    }

    func eventMembers(id: UUID) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.eventMembers(id: id))
    }

    func updateEvent(info: Event) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.updateEvent(info: info))
    }

    func getEvents() async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.getEvents())
    }

    func acceptUser(eventId: UUID, userId: UUID) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.acceptUser(eventId: eventId, userId: userId))
    }

    func myEvents() async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.myEvents())
    }

    func membership(number: Int) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.membership(number: number))
    }

}

// MARK: - Endpoint

enum RecommendationsNetworkingEndpoint: TokenizedEndpoint {

    case create(event: Event)
    case joinEvent(id: UUID)
    case eventMembers(id: UUID)
    case updateEvent(info: Event)
    case getEvents
    case acceptUser(eventId: UUID, userId: UUID)
    case myEvents
    case membership(number: Int)

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

    var body: [String : String]? {
        switch self {
        case .create(event: let event):
            return [
                "id": event.id.uuidString,
                "title": event.name,
                "description": event.description,
                "photos": "\(event.images.map { $0.jpegData(compressionQuality: 1) })",
                "date": event.date.timeIntervalSince1970.description
            ]

        case .membership, .myEvents, .getEvents, .eventMembers, .joinEvent:
            return [:]

        case .updateEvent(info: let info):
            return [
                "id": info.id.uuidString,
                "title": info.name,
                "description": info.description,
                "photos": "\(info.images.map { $0.jpegData(compressionQuality: 1) })",
                "date": info.date.timeIntervalSince1970.description
            ]

        case .acceptUser(eventId: let eventId, userId: let userId):
            return [
                "event": eventId.uuidString,
                "userId": userId.uuidString
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

    static func create(event: Event) async -> Self {
        .init(endpoint: RecommendationsNetworkingEndpoint.create(event: event))
    }

    static func joinEvent(id: UUID) async -> Self {
        .init(endpoint: RecommendationsNetworkingEndpoint.joinEvent(id: id))
    }

    static func eventMembers(id: UUID) async -> Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.eventMembers(id: id))
    }

    static func updateEvent(info: Event) async -> Self {
        .init(endpoint: RecommendationsNetworkingEndpoint.updateEvent(info: info))
    }

    static func getEvents() async -> Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.getEvents)
    }

    static func acceptUser(eventId: UUID, userId: UUID) async -> Self {
        .init(endpoint: RecommendationsNetworkingEndpoint.acceptUser(eventId: eventId, userId: userId))
    }

    static func myEvents() async -> Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.myEvents)
    }

    static func membership(number: Int) async -> Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.membership(number: number))
    }

}

