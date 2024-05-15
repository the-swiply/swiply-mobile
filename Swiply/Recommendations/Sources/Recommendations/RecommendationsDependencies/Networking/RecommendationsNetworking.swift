import Dependencies
import Networking
import SYCore

// MARK: - ProfilesService

protocol RecommendationsNetworking {

    func getProfiles(number: Int) async -> Result<RecommendationsResponse, RequestError>

}

// MARK: - DependencyKey

enum RecommendationsNetworkingKey: DependencyKey {

    public static var liveValue: any RecommendationsNetworking = LiveRecommendationsNetworking()

}

// MARK: - DependencyValues

extension DependencyValues {

    var recommendationsNetworking: any RecommendationsNetworking {
        get { self[RecommendationsNetworkingKey.self] }
        set { self[RecommendationsNetworkingKey.self] = newValue }
    }

}


// MARK: - LiveProfilesService

class LiveRecommendationsNetworking: LiveTokenUpdatableClient, RecommendationsNetworking {

    func getProfiles(number: Int) async -> Result<RecommendationsResponse, RequestError> {
        await sendRequest(.getProfiles(number: number))
    }

}

// MARK: - Endpoint

enum RecommendationsNetworkingEndpoint: TokenizedEndpoint {

    case getProfiles(number: Int)

    var path: String {
        switch self {
        case .getProfiles:
            "/v1/get-recommendations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfiles:
            .post
        }
    }

    var body: [String : String]? {
        switch self {
        case .getProfiles(let number):
            ["limit": number.description]
        }
    }

    #if DEBUG

    var port: Int? {
        18083
    }

    #endif

}

// MARK: - Extension Request

private extension Request {

    static func getProfiles(number: Int) -> Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.getProfiles(number: number))
    }

}

