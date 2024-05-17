import Dependencies
import Networking
import SYCore

// MARK: - ProfilesService

protocol RecommendationsNetworking {

    func getMatches() async -> Result<RecommendationsResponse, RequestError>
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

    func getMatches() async -> Result<RecommendationsResponse, RequestError> {
        await sendRequest(.getMatches)
    }

    func getProfiles(number: Int) async -> Result<RecommendationsResponse, RequestError> {
        await sendRequest(.getProfiles(number: number))
    }

}

// MARK: - Endpoint

enum RecommendationsNetworkingEndpoint: TokenizedEndpoint {

    case getProfiles(number: Int)
    case getMatches

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "recommendation"
    }

    var path: String {
        switch self {
        case .getProfiles:
            "/v1/get-recommendations"

        case .getMatches:
            "/v1/profile/list-matches"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfiles:
            .post

        case .getMatches:
            .get
        }
    }

    var body: [String : Codable]? {
        switch self {
        case .getProfiles(let number):
            ["limit": number.description]

        case .getMatches:
            nil
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

    static var getMatches: Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.getMatches)
    }

    static func getProfiles(number: Int) -> Self {
        .init(requestTimeout: .infinite, endpoint: RecommendationsNetworkingEndpoint.getProfiles(number: number))
    }

}

