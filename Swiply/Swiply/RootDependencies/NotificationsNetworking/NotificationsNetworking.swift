import Foundation
import Dependencies
import Networking
import SYCore

// MARK: - EventsNetworking

protocol NotificationsNetworking {

    func subscribe(token: String) async -> Result<EmptyResponse, RequestError>

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

}

// MARK: - Endpoint

enum NotificationsNetworkingEndpoint: TokenizedEndpoint {

    case subscribe(token: String)

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
        }
    }

    var method: HTTPMethod {
        switch self {
        case .subscribe:
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

}

