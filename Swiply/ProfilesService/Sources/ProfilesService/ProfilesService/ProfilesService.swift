import Foundation
import ComposableArchitecture
import Networking
import SYCore
import SwiftUI

// MARK: - ProfilesService

public protocol ProfilesService {

    func getProfile(id: String) async -> Result<Profile, RequestError>
    func createProfile(profile: CreatedProfile) async -> Result<UserID, RequestError>
    func whoAmI() async -> Result<UserID, RequestError>
    func createPhoto(photo: String) async -> Result<String, RequestError>
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

        var profile: Profile

        switch getProfileResult {
        case let .failure(error):
            return .failure(error)

        case let .success(serverProfile):
            profile = serverProfile.userProfile.toProfile
        }

        let imagesReferense = LoadableImageCollection()
        profile.images = imagesReferense

        Task { [profilesServiceNetworking] in
            let getPhotosResult = await profilesServiceNetworking.getPhotos(id: id)

            switch getPhotosResult {
            case let .failure(error):
                break

            case let .success(images):
                let profileImages = images.photos.compactMap { imageString in
                    if let data = Data(base64Encoded: imageString.content, options: .ignoreUnknownCharacters) {
                        return UIImage(data: data)
                    }

                    return nil
                }

                imagesReferense.images = profileImages.map { image in
                    return .image(image)
                }
            }
        }
        
        return .success(profile)
    }
    
    func whoAmI() async -> Result<UserID, Networking.RequestError> {
        let findProfileResult = await profilesServiceNetworking.whoAmI()
        
        switch findProfileResult {
        case let .success(userId):
            return .success(userId)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func createProfile(profile: CreatedProfile) async -> Result<UserID, Networking.RequestError> {
        let createProfileResult = await profilesServiceNetworking.createProfile(profile: profile)
        
        let userId: UserID
        switch createProfileResult {
        case let .failure(error):
            return .failure(error)

        case let .success(userID):
            userId = userID
        }
        
        guard let photo = profile.images.first??.toJpegString(compressionQuality: 0.0) else {
            return .success(userId)
        }
        
        let createPhotoResult = await profilesServiceNetworking.createPhoto(photo: photo)
        
        switch createPhotoResult {
        case let .failure(error):
            break

        case .success:
            break
        }
        return .success(userId)
    
    }
    
    func createPhoto(photo: String) async -> Result<String, Networking.RequestError> {
        let createPhoto = await profilesServiceNetworking.createPhoto(photo: photo)
        
        switch createPhoto {
        case let .failure(error):
            return .failure(error)

        case let .success(userID):
            return .success(userID)
        }
    }
}

