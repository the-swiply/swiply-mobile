import Foundation
import ComposableArchitecture
import Networking
import SYCore
import SwiftUI

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
        let getProfileResult = await profilesServiceNetworking.getProfile(id: id)

        let profile: Profile

        switch getProfileResult {
        case let .failure(error):
            return .failure(error)

        case let .success(serverProfile):
            profile = serverProfile.userProfile.toProfile
        }

        Task { [profilesServiceNetworking] in
            let getPhotosResult = await profilesServiceNetworking.getPhotos(id: id)

            switch getPhotosResult {
            case let .failure(error):
                break

            case let .success(images):
                let profileImages = images.content.compactMap { imageString in
                    if let data = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters) {
                        return UIImage(data: data)
                    }

                    return nil
                }

                profile.images.images = profileImages.map { image in
                    return .image(Image(uiImage: image))
                }
            }
        }

        return .success(profile)
    }

}
