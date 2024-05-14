import Dependencies
import Networking

// MARK: - ProfilesServiceNetworking

public protocol ProfilesServiceNetworking {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError>
    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError>
    func getLikes() async -> Result<IDListResponse, RequestError>
    func createProfile(profile: CreatedProfile) async -> Result<String, RequestError>
    func whoAmI() async -> Result<UserID, RequestError>

}

// MARK: - DependencyKey

enum ProfilesServiceNetworkingKey: DependencyKey {

    public static var liveValue: any ProfilesServiceNetworking = LiveProfilesServiceNetworking()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var profilesServiceNetworking: any ProfilesServiceNetworking {
        get { self[ProfilesServiceNetworkingKey.self] }
        set { self[ProfilesServiceNetworkingKey.self] = newValue }
    }

}


// MARK: - LiveProfilesServiceNetworking

class LiveProfilesServiceNetworking: LiveTokenUpdatableClient, ProfilesServiceNetworking {
    
    func createProfile(profile: CreatedProfile) async -> Result<String, Networking.RequestError> {
        await sendRequest(.createProfile(profile: profile))
    }

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError> {
        await sendRequest(.getProfile(id: id))
    }

    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError> {
        await sendRequest(.getPhotos(id: id))
    }

    func getLikes() async -> Result<IDListResponse, RequestError> {
        await sendRequest(.getLikes)
    }
    
    func whoAmI() async -> Result<UserID, Networking.RequestError> {
        await sendRequest(.whoAmI)
    }

}

// MARK: - Endpoint

enum ProfilesServiceNetworkingEndpoint: TokenizedEndpoint {

    case getProfile(id: String)
    case getPhotos(id: String)
    case getLikes
    case createProfile(CreatedProfile)
    case whoAmI

    var path: String {
        switch self {
        case .getProfile:
            "/v1/profile"

        case .getLikes:
            "/v1/profile/liked-me"

        case .getPhotos:
            "/v1/photo"
            
        case .createProfile:
            "/v1/profile/create"
            
        case .whoAmI:
            "/v1/profile/who-am-i"
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
            
        case .createProfile:
            []
            
        case .whoAmI:
            []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile,
             .getLikes,
             .getPhotos,
             .whoAmI:
            .get
        case .createProfile:
                .post
        }
    }

    var body: [String : String]? {
        switch self {
        case .getLikes,
             .getPhotos,
             .whoAmI,
             .getProfile:
            return nil
            
        case let .createProfile(profile):
            return [
                "email": profile.email,
                "name": profile.name,
                "birth_day": "2024-05-10T20:12:00.326Z",
                "gender": profile.gender.rawValue,
                "info": profile.description,
                "subscriptionType": "STANDARD",
                "city": profile.town,
                "work": profile.work,
                "education": profile.education
            ]
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

    static var getLikes: Self {
        .init(requestTimeout: .infinite, endpoint: ProfilesServiceNetworkingEndpoint.getLikes)
    }

    static func getProfile(id: String) -> Self {
        .init(requestTimeout: .infinite, endpoint: ProfilesServiceNetworkingEndpoint.getProfile(id: id))
    }

    static func getPhotos(id: String) -> Self {
        .init(requestTimeout: .infinite, endpoint: ProfilesServiceNetworkingEndpoint.getPhotos(id: id))
    }
    
    static func createProfile(profile: CreatedProfile) -> Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.createProfile(profile))
    }
    
    static var whoAmI: Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.whoAmI)
    }

}


