import Dependencies
import Networking
import SYCore

// MARK: - ProfilesService

public protocol RecommendationsService {

    func getProfiles(number: Int) async -> Result<[Profile], BaseError>

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

// MARK: - LiveProfilesService

class LiveRecommendationsService: RecommendationsService {

    @Dependency(\.recommendationsNetworking) var recommendationsNetworking
    @Dependency(\.profilesService) var profilesService

    func getProfiles(number: Int) async -> Result<[Profile], BaseError> {
//        profilesService.getProfile(id: <#T##String#>)
        return .failure(.error)
    }

}
