import Foundation
import Dependencies
import Networking
import SYCore
import Foundation

// MARK: - ProfilesServiceNetworking 

public protocol ProfilesServiceNetworking {

   
    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError>
    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError>
    func getLikes() async -> Result<IDListResponse, RequestError>
    func interactWithProfile(_ id: UUID, interactionType: ProfileInteraction) async -> Result<EmptyResponse, RequestError>
    func whoAmI() async -> Result<UserID, RequestError>
    func createProfile(profile: CreatedProfile) async -> Result<UserID, RequestError>
    func createPhoto(photo: String) async -> Result<PhotoID, RequestError>
    func updateProfile(profile: Profile) async -> Result<UserID, Networking.RequestError> 
    func getInterestsLists() async -> Result<ListInterestResponse, RequestError>
    func deletePhoto(id: String) async -> Result<Bool, RequestError>
    func reoderPhotos(ids: [String]) async -> Result<EmptyResponse, RequestError>
    func getMatches() async -> Result<MatchesResponse, RequestError>

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

    func interactWithProfile(_ id: UUID, interactionType: ProfileInteraction) async -> Result<EmptyResponse, RequestError> {
        await sendRequest(.interactWithProfile(id, interactionType: interactionType))
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

    func createPhoto(photo: String) async -> Result<PhotoID, Networking.RequestError> {
        await sendRequest(.createPhoto(photoStr: photo))
    }
    
    func getInterestsLists() async -> Result<ListInterestResponse, Networking.RequestError> {
        await sendRequest(.getInterestsLists)
    }
    
    func updateProfile(profile: Profile) async -> Result<UserID, Networking.RequestError>  {
        await sendRequest(.updateProfile(profile: profile))
    }
    
    func deletePhoto(id: String) async -> Result<Bool, Networking.RequestError> {
        await sendRequest(.deletePhoto(id: id))
    }
    
    func reoderPhotos(ids: [String]) async -> Result<EmptyResponse, Networking.RequestError> {
        await sendRequest(.reoderPhotos(ids: ids))
    }

    func getMatches() async -> Result<MatchesResponse, RequestError> {
        await sendRequest(.getMatches)
    }

}

// MARK: - Endpoint

enum ProfilesServiceNetworkingEndpoint: TokenizedEndpoint {

    case interactWithProfile(_ id: UUID, interactionType: ProfileInteraction)
    case getProfile(id: String)
    case getPhotos(id: String)
    case getLikes
    case createProfile(CreatedProfile)
    case createPhoto(String)
    case whoAmI
    case getInterestsLists
    case updateProfile(Profile)
    case deletePhoto(String)
    case reoderPhotos(ids: [String])
    case getMatches

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "profile"
    }

    var path: String {
        switch self {
        case .interactWithProfile:
            "/v1/interaction/create"

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
            
        case .getInterestsLists:
            "/v1/interests"
            
        case .updateProfile:
            "/v1/profile/update"
            
        case .deletePhoto:
            "/v1/photo/delete"
            
        case .reoderPhotos:
            "/v1/photo/reorder"
            
        case .getMatches:
            "/v1/profile/list-matches"
        }
    }

    var pathComponents: [String] {
        switch self {
        case .getProfile(let id):
            [id]

        case .getPhotos(let id):
            [id]

        case .getLikes, .interactWithProfile:
            []
            
        case .createProfile:
            []
            
        case .whoAmI:
            []
            
        case .createPhoto, .updateProfile:
           []
            
        case .getInterestsLists:
           []
        case .deletePhoto:
            []
        case .reoderPhotos:
            []

        case .getMatches:
            []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile,
             .getLikes,
             .getPhotos,
             .whoAmI,
             .getMatches,
             .getInterestsLists:
            .get

        case .createProfile,
                .createPhoto,
                .updateProfile,
                .deletePhoto,
                .reoderPhotos,
                .interactWithProfile:
                .post
        }
    }

    var jsonStr: String? {
        switch self {
        case let .createProfile(profile):
            let request = CreateProfileRequest(profile)
            return request.toJSONStr()
            
        case let .updateProfile(profile):
            let request = UpdateProfileRequest(profile)
            return request.toJSONStr()
            
        default:
            return nil
        }
    }
    
    var body: [String : Codable]? {
        switch self {
        case let .interactWithProfile(id, interactionType):
            return [
                "id": id.uuidString.lowercased(),
                "type": interactionType.rawValue
            ]

        case .getLikes,
             .getPhotos,
             .whoAmI,
             .getProfile,
             .getMatches,
             .getInterestsLists:
            return nil
            
        case let .createProfile(profile):
            return nil
            
        case let .createPhoto(photoStr):
            return ["content": photoStr]
            
        case let .updateProfile(profile):
            return nil
            
        case let .deletePhoto(id):
            return [
                "id": id
            ]
            
        case let .reoderPhotos(ids):
            return [
                "ids": ids
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

    static func interactWithProfile(_ id: UUID, interactionType: ProfileInteraction) -> Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.interactWithProfile(id, interactionType: interactionType))
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
    
    static var getInterestsLists: Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.getInterestsLists)
    }
    
    static func updateProfile(profile: Profile) -> Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.updateProfile(profile))
    }
    
    static func deletePhoto(id: String) -> Self {
        .init(requestTimeout: .infinite, endpoint: ProfilesServiceNetworkingEndpoint.deletePhoto(id))
    }
    
    static func reoderPhotos(ids: [String]) -> Self {
        .init(requestTimeout: .infinite, endpoint: ProfilesServiceNetworkingEndpoint.reoderPhotos(ids: ids))
    }

    static var getMatches: Self {
        .init(endpoint: ProfilesServiceNetworkingEndpoint.getMatches)
    }

}



