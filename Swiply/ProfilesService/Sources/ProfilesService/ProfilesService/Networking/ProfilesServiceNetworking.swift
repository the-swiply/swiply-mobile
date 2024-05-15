import Foundation
import Dependencies
import Networking

// MARK: - ProfilesServiceNetworking

public protocol ProfilesServiceNetworking {

    func getProfile(id: String) async -> Result<UserProfileResponse, RequestError>
    func getPhotos(id: String) async -> Result<PhotosResponse, RequestError>
    func getLikes() async -> Result<IDListResponse, RequestError>
    func interactWithProfile(_ id: UUID, interactionType: ProfileInteraction) async -> Result<EmptyResponse, RequestError>

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

}

// MARK: - Endpoint

enum ProfilesServiceNetworkingEndpoint: TokenizedEndpoint {

    case interactWithProfile(_ id: UUID, interactionType: ProfileInteraction)
    case getProfile(id: String)
    case getPhotos(id: String)
    case getLikes

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
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile,
             .getLikes,
             .getPhotos:
            .get

        case .interactWithProfile:
            .post
        }
    }

    var body: [String : String]? {
        switch self {
        case .getProfile,
             .getLikes,
             .getPhotos:
            nil

        case let .interactWithProfile(id, interactionType):
            [
                "id": id.uuidString,
                "type": interactionType.rawValue
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

}


