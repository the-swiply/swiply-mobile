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
    func getInterestsLists() async -> Result<ListInterestResponse, RequestError>
    func updateProfile(profile: Profile) async -> Result<UserID, RequestError>
    func deletePhoto(id: String) async -> Result<Bool, RequestError>
    func reoderPhotos(ids: [String]) async -> Result<EmptyResponse, RequestError>
    func likeProfile(id: UUID) async -> Result<EmptyResponse, BaseError>
    func dislikeProfile(id: UUID) async -> Result<EmptyResponse, BaseError>
    func updatePhoto(old: Profile, new: Profile) async -> Result<EmptyResponse, BaseError>
    func getMatches() async -> Result<[String], RequestError>

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
                        return ImageInfo(image: UIImage(data: data) ?? UIImage(resource: .noPhoto), uuid: imageString.id)
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

    func getMatches() async -> Result<[String], RequestError> {
        let response = await profilesServiceNetworking.getMatches()

        switch response {
        case let .success(profiles):
            return .success(profiles.ids)

        case let .failure(error):
            return .failure(error)
        }
    }

    func whoAmI() async -> Result<UserID, RequestError> {
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
        
       await withTaskGroup(
            of: Result<PhotoID, RequestError>.self
        ) { taskGroup in
            for photo in profile.images {
                if let photo = photo?.toJpegString(compressionQuality: 0.0) {
                    taskGroup.addTask {
                        await self.profilesServiceNetworking.createPhoto(photo: photo)
                    }
                }
            }
        }
        return .success(userId)
    
    }
    
    func createPhoto(photo: String) async -> Result<String, Networking.RequestError> {
        let createPhoto = await profilesServiceNetworking.createPhoto(photo: photo)
        
        switch createPhoto {
        case let .failure(error):
            return .failure(error)

        case let .success(userID):
            return .success(userID.id)
        }
    }
    
    func getInterestsLists() async -> Result<ListInterestResponse, Networking.RequestError> {
        let createPhoto = await profilesServiceNetworking.getInterestsLists()
        
        switch createPhoto {
        case let .failure(error):
            return .failure(error)

        case let .success(list):
            var listNew = [Interest]()
            for i in 0..<list.interests.count {
                if i < 25 {
                    listNew.append(list.interests[i])
                }
            }
            return .success(ListInterestResponse(interests: listNew))
        }
    }
    
    func updateProfile(profile: Profile) async -> Result<UserID, Networking.RequestError> {
        let updateProfile = await profilesServiceNetworking.updateProfile(profile: profile)
        switch updateProfile {
        case let .failure(error):
            return .failure(error)

        case let .success(userID):
            return .success(userID)
        }
    }
    
    func deletePhoto(id: String) async -> Result<Bool, Networking.RequestError> {
        let deletePhoto = await profilesServiceNetworking.deletePhoto(id: id)
        switch deletePhoto {
        case let .failure(error):
            return .failure(error)

        case let .success(userID):
            return .success(userID)
        }
    }
    
    func reoderPhotos(ids: [String]) async -> Result<EmptyResponse, RequestError> {
        let reoderPhotos = await profilesServiceNetworking.reoderPhotos(ids: ids)
        switch reoderPhotos {
        case let .failure(error):
            return .failure(error)

        case let .success(userID):
            return .success(userID)
        }
    }

    func likeProfile(id: UUID) async -> Result<EmptyResponse, BaseError> {
        let response = await profilesServiceNetworking.interactWithProfile(id, interactionType: .like)

        switch response {
        case .success:
            return .success(.init())

        case .failure:
            return .failure(.error)
        }
    }

    func dislikeProfile(id: UUID) async -> Result<EmptyResponse, BaseError> {
        let response = await profilesServiceNetworking.interactWithProfile(id, interactionType: .dislike)

        switch response {
        case .success:
            return .success(.init())

        case .failure:
            return .failure(.error)
        }
    }
    
    func updatePhoto(old: Profile, new: Profile) async -> Result<EmptyResponse, BaseError> {
        var newImages = [ImageInfo]()
        
        new.images.images.forEach { img in
            switch img {
            case .loading:
                break
            case let .image(imageInfo):
                newImages.append(imageInfo)
            }
        }
        
        var oldImages = [ImageInfo]()
        
        old.images.images.forEach { img in
            switch img {
            case .loading:
                break
            case let .image(imageInfo):
                oldImages.append(imageInfo)
            }
        }
        
        let deletePhotos = oldImages.filter { old in !newImages.contains(where: { $0.uuid == old.uuid }) }
        
        await withTaskGroup(
             of: Void.self
        ) { taskGroup in
            for photo in deletePhotos {
                taskGroup.addTask {
                    await self.profilesServiceNetworking.deletePhoto(id: photo.uuid)
                }
            }
        }
        
        for i in 0..<newImages.count {
            if newImages[i].uuid.isEmpty, let photo = newImages[i].image.toJpegString(compressionQuality: 0.0)  {
                let response = await profilesServiceNetworking.createPhoto(photo: photo)
                switch response {
                case let .success(photo):
                    newImages[i].uuid = photo.id
                case .failure:
                    break
                }
            }
        }
      
        let resp = await profilesServiceNetworking.reoderPhotos(ids: newImages.compactMap {$0.uuid})
        
        switch resp {
        case .success:
            return .success(.init())

        case .failure:
            return .failure(.error)
        }
    }
    
}

