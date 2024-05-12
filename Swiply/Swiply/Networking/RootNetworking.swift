import Dependencies
import Networking

// MARK: - ProfilesServiceNetworking

public protocol RootServiceNetworking {
    
    func whoAmI() async -> Result<UserID, RequestError>

}

// MARK: - DependencyKey

enum RootServiceNetworkingKey: DependencyKey {

    public static var liveValue: any RootServiceNetworking = LiveRootServiceNetworking()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var rootServiceNetworking: any RootServiceNetworking {
        get { self[RootServiceNetworkingKey.self] }
        set { self[RootServiceNetworkingKey.self] = newValue }
    }

}


// MARK: - LiveProfilesServiceNetworking

class LiveRootServiceNetworking: LiveTokenUpdatableClient, RootServiceNetworking {
    
    func whoAmI() async -> Result<UserID, Networking.RequestError> {
        await sendRequest(.whoAmI)
    }

}

// MARK: - Endpoint

enum RootServiceNetworkingEndpoint: TokenizedEndpoint {

    case whoAmI

    var path: String {
        switch self {
        case .whoAmI:
            "/v1/profile/who-am-i"
        }
    }

    var pathComponents: [String] {
        switch self {
        case .whoAmI:
            []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .whoAmI:
                .get
        }
    }

    var body: [String : String]? {
        switch self {
        case .whoAmI:
            return nil
        }
    }

    #if DEBUG

    var port: Int? {
        18086
    }

    #endif

}

// MARK: - Extension Request

private extension Request {
    
    static var whoAmI: Self {
        .init(endpoint: RootServiceNetworkingEndpoint.whoAmI)
    }

}


public struct UserID: Decodable {
    let id: String
}
