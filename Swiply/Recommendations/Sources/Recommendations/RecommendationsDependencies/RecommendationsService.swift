import Dependencies
import Networking
import SYCore

// MARK: - UserService

public protocol RecommendationsService {

    func getProfiles(number: Int) async -> Result<Profile, RequestError>

}

// MARK: - DependencyKey

enum RecommendationsServiceKey: DependencyKey {

    public static var liveValue: any RecommendationsService = LiveRecommendationsService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var recommendationsService: any RecommendationsService {
        get { self[RecommendationsServiceKey.self] }
        set { self[RecommendationsServiceKey.self] = newValue }
    }

}


// MARK: - LiveUserService

class LiveRecommendationsService: LiveTokenUpdatableClient, RecommendationsService {

    func getProfiles(number: Int) async -> Result<Profile, RequestError> {
        .failure(.decode)
    }

}

// MARK: - Endpoint

enum RecommendationsServiceEndpoint: TokenizedEndpoint {

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

    var port: Int {
        18083
    }

    #endif

}

