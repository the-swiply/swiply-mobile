import Dependencies
import Networking

// MARK: - UserService

public protocol UserService {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError>
    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError>
    func getLikes() async -> Result<IDListResponse, RequestError>

}

// MARK: - DependencyKey

enum UserServiceKey: DependencyKey {

    public static var liveValue: any UserService = LiveUserService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var userService: any UserService {
        get { self[UserServiceKey.self] }
        set { self[UserServiceKey.self] = newValue }
    }

}


// MARK: - LiveUserService

class LiveUserService: LiveTokenUpdatableClient, UserService {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError> {
        await sendRequest(endpoint: UserServiceEndpoint.getProfile(id: id))
    }

    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError> {
        await sendRequest(endpoint: UserServiceEndpoint.getPhotos(id: id))
    }

    func getLikes() async -> Result<IDListResponse, RequestError> {
        await sendRequest(endpoint: UserServiceEndpoint.getLikes)
    }

}

// MARK: - Endpoint

enum UserServiceEndpoint: TokenizedEndpoint {

    case getProfile(id: String)
    case getPhotos(id: String)
    case getLikes

    var path: String {
        switch self {
        case .getProfile:
            "/v1/profile"

        case .getLikes:
            "/v1/profile/liked-me"

        case .getPhotos:
            "/v1/photo"
        }
    }

    var pathComponents: [String] {
        switch self {
        case .getProfile(let id):
            [id]

        case .getPhotos(let id):
            [id]

        case .getLikes:
            []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile,
             .getLikes,
             .getPhotos:
            .get
        }
    }

    var body: [String : String]? {
        switch self {
        case .getProfile,
             .getLikes,
             .getPhotos:
            nil
        }
    }

    #if DEBUG

    var port: Int {
        18086
    }

    #endif

}
