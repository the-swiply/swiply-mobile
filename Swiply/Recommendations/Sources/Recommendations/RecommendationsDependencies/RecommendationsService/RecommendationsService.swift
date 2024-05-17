import Foundation
import Combine
import Dependencies
import Networking
import SYCore

// MARK: - RecommendationsService

public protocol RecommendationsService {

    var publisher: AnyPublisher<[Profile], Never> { get }

    func removeProfile(with id: UUID) async
    func returnToLastProfile() async
    func loadProfiles(number: Int) async
    func dislikeProfile(id: UUID) async
    func likeProfile(id: UUID) async
    func filterProfiles(age: ClosedRange<Int>, gender: ProfileGender) async
    func lastProfile() async -> Profile?

}

// MARK: - DependencyKey

enum RecommendationsServiceKey: DependencyKey {

    public static var liveValue: any RecommendationsService = LiveRecommendationsService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var recommendationsService: any RecommendationsService {
        get { self[RecommendationsServiceKey.self] }
        set { self[RecommendationsServiceKey.self] = newValue }
    }

}

// MARK: - LiveRecommendationsService

actor LiveRecommendationsService: RecommendationsService {

    @Dependency(\.recommendationsNetworking) var recommendationsNetworking
    @Dependency(\.profilesService) var profilesService

    let publisher: AnyPublisher<[Profile], Never>

    private let profilesSubject: CurrentValueSubject<[Profile], Never>

    private var profiles: [Profile] = [] {
        didSet {
            profilesSubject.send(profiles)
        }
    }

    private var buffer: [Profile] = []

    init() {
        let subject = CurrentValueSubject<[Profile], Never>(.init())
        profilesSubject = subject
        publisher = subject.eraseToAnyPublisher()
    }

    func dislikeProfile(id: UUID) async {
        let _ = await profilesService.dislikeProfile(id: id)

        if let profile = profiles.first(where: { $0.id == id }) {
            buffer.append(profile)
        }
    }
    
    func likeProfile(id: UUID) async {
        let _ = await profilesService.likeProfile(id: id)

        if let profile = profiles.first(where:  { $0.id == id }) {
            buffer.append(profile)
        }
    }

    func returnToLastProfile() async {
        if let profile = buffer.last {
            buffer.removeLast()
            profiles.append(profile)
        }
    }

    func lastProfile() async -> Profile? {
        buffer.last
    }

    func removeProfile(with id: UUID) async {
        let deletedProfile = profiles.first(where: { profile in
            profile.id == id
        })

        if let deletedProfile {
            buffer.append(deletedProfile)
        }

        profiles.removeAll(where: { profile in
            profile.id == id
        })
    }


    func loadProfiles(number: Int) async {
        let idsResponse = await recommendationsNetworking.getProfiles(number: number)
        print(idsResponse)

        await withTaskGroup(of: Result<Profile, RequestError>.self) { taskGroup in
            switch idsResponse {
            case .failure:
                break

            case let .success(ids):
                ids.userIDs.forEach { id in
                    taskGroup.addTask {
                        await self.profilesService.getProfile(id: id)
                    }
                }

                for await profileResponse in taskGroup { 
                    switch profileResponse {
                    case .failure:
                        break

                    case let .success(profile):
                        Task {
                            await updateProfiles(newProfile: profile)
                        }
                    }
                }
            }
        }
    }

    func updateProfiles(newProfile: Profile) async {
        if profiles.isEmpty {
            profiles.append(newProfile)
        }
        else {
            profiles.insert(newProfile, at: profiles.count - 1)
        }
    }

    func filterProfiles(age: ClosedRange<Int>, gender: ProfileGender) async {
        profiles = profiles.filter { profile in
            age.contains(profile.age.getAge())
            && profile.gender.isSutisfies(filter: gender)
        }
    }

    private func getProfiles(number: Int) async -> Result<[Profile], BaseError> {
        let imagesResponse = await withTaskGroup(
            of: Result<Profile, RequestError>.self,
            returning: Result<[Profile], RequestError>.self) { [profilesService] taskGroup in

            let idsResponse = await recommendationsNetworking.getProfiles(number: number)

            switch idsResponse {
            case let .failure(error):
                return .failure(error)

            case let .success(ids):
                var profiles = [Profile]()

                ids.userIDs.forEach { id in
                    taskGroup.addTask {
                        await profilesService.getProfile(id: id)
                    }
                }

                for await profileResponse in taskGroup {
                    switch profileResponse {
                    case let .failure(error):
                        return .failure(error)

                    case let .success(profile):
                        profiles.append(profile)
                    }
                }

                return .success(profiles)
            }
        }

        switch imagesResponse {
        case .failure:
            return .failure(.error)

        case let .success(profiles):
            return .success(profiles)
        }
    }

}
