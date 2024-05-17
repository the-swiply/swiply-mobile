import Foundation
import Dependencies
import Networking
import SYCore

// MARK: - EventsNetworking

protocol NotificationsNetworking {

    func subscribe(token: String) async -> Result<EmptyResponse, RequestError>
    func unsubscribe() async -> Result<EmptyResponse, RequestError>

}

// MARK: - DependencyKey

enum NotificationsNetworkingKey: DependencyKey {

    public static var liveValue: any NotificationsNetworking = LiveNotificationsNetworking()

}

// MARK: - DependencyValues

extension DependencyValues {

    var notificationsNetworking: any NotificationsNetworking {
        get { self[NotificationsNetworkingKey.self] }
        set { self[NotificationsNetworkingKey.self] = newValue }
    }

}


// MARK: - LiveNotificationsNetworking

class LiveNotificationsNetworking: LiveTokenUpdatableClient, NotificationsNetworking {

    func subscribe(token: String) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.subscribe(token: token))
    }

    func unsubscribe() async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.unsubscribe())
    }

}

// MARK: - Endpoint

enum NotificationsNetworkingEndpoint: TokenizedEndpoint {

    case subscribe(token: String)
    case unsubscribe

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "notification"
    }


    var path: String {
        switch self {
        case .subscribe:
            "/v1/notification/subscribe"

        case .unsubscribe:
            "/v1/notification/unsubscribe"
        }
    }

//    var pathComponents: [String] {
//        switch self {
//        case let .subscribe(token):
//            [token.description]
//        }
//    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .subscribe(token):
            [.init(name: "device_token", value: token.description)]

        case .unsubscribe:
            nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .subscribe, .unsubscribe:
            return .post
        }
    }

    var body: [String : any Codable]? {
        nil
    }

    #if DEBUG

    var port: Int? {
        18084
    }

    #endif

}

// MARK: - Extension Request

private extension Request {

    static func subscribe(token: String) -> Self {
        .init(requestTimeout: .infinite, endpoint: NotificationsNetworkingEndpoint.subscribe(token: token))
    }

    static func unsubscribe() -> Self {
        .init(requestTimeout: .infinite, endpoint: NotificationsNetworkingEndpoint.unsubscribe)
    }

}

