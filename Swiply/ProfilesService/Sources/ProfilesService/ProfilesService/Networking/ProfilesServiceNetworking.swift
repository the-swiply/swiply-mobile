import Dependencies
import Networking

// MARK: - ProfilesServiceNetworking

public protocol ProfilesServiceNetworking {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError>
    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError>
    func getLikes() async -> Result<IDListResponse, RequestError>
    func whoAmI() async -> Result<UserID, RequestError>
    func createProfile(profile: CreatedProfile) async -> Result<UserID, RequestError>
    func createPhoto(photo: String) async -> Result<String, RequestError>
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
    
    func createProfile(profile: CreatedProfile) async -> Result<UserID, Networking.RequestError> {
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

    func createPhoto(photo: String) async -> Result<String, Networking.RequestError> {
        await sendRequest(.createPhoto(photoStr: photo))
    }
}

// MARK: - Endpoint

enum ProfilesServiceNetworkingEndpoint: TokenizedEndpoint {

    case getProfile(id: String)
    case getPhotos(id: String)
    case getLikes
    case createProfile(CreatedProfile)
    case createPhoto(String)
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
            
        case .createPhoto:
            "/v1/photo/create"
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
            
        case .createPhoto:
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
        case .createProfile,
                .createPhoto:
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
        case let .createPhoto(photoStr):
            return ["content": photoStr]
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
    
    static var whoAmI: Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.whoAmI)
    }
    
    static func createProfile(profile: CreatedProfile) -> Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.createProfile(profile))
    }
    
    static func createPhoto(photoStr: String) -> Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.createPhoto(photoStr))
    }

}


