import Dependencies
import Networking

// MARK: - ProfilesService

public protocol ProfilesService {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError>
    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError>
    func getLikes() async -> Result<IDListResponse, RequestError>

}

// MARK: - DependencyKey

enum ProfilesServiceKey: DependencyKey {

    public static var liveValue: any ProfilesService = LiveProfilesService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var profilesService: any ProfilesService {
        get { self[ProfilesServiceKey.self] }
        set { self[ProfilesServiceKey.self] = newValue }
    }

}


// MARK: - LiveProfilesService

class LiveProfilesService: LiveTokenUpdatableClient, ProfilesService {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError> {
        await sendRequest(endpoint: ProfilesServiceEndpoint.getProfile(id: id))
    }

    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError> {
        await sendRequest(endpoint: ProfilesServiceEndpoint.getPhotos(id: id))
    }

    func getLikes() async -> Result<IDListResponse, RequestError> {
        await sendRequest(endpoint: ProfilesServiceEndpoint.getLikes)
    }

}

// MARK: - Endpoint

enum ProfilesServiceEndpoint: TokenizedEndpoint {

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
