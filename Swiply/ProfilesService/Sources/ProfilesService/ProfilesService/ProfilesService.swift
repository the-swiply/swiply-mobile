import Foundation
import ComposableArchitecture
import Networking
import SYCore

// MARK: - ProfilesService

public protocol ProfilesService {

    func getProfile(id: String) async -> Result<Profile, RequestError>

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

class LiveProfilesService: ProfilesService {

    private enum Constant {

        static let storageURL = URL.documentsDirectory.appending(component: "Profiles")

    }

    @Shared(.fileStorage(Constant.storageURL)) private var profiles: [StorableProfile] = []
    @Dependency(\.profilesServiceNetworking) private var profilesServiceNetworking

    func getProfile(id: String) async -> Result<Profile, RequestError> {
//        let getProfileResult = await profilesServiceNetworking.getProfile(id: id)
//        await profilesServiceNetworking.getPhotos(id: id)
        .failure(.decode)
    }

}
