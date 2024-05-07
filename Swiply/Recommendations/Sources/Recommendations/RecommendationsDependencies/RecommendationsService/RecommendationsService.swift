import Dependencies
import Networking
import SYCore

// MARK: - UserService

public protocol RecommendationsService {

    func getProfiles(number: Int) async -> [Profile]

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

// MARK: - LiveUserService

class LiveRecommendationsService: LiveTokenUpdatableClient, RecommendationsService {

    @Dependency(\.recommendationsNetworking) var recommendationsNetworking
    @Dependency(\.userService) var userService

    func getProfiles(number: Int) async -> [Profile] {
        []
    }

}
