import Foundation
import Combine
import Dependencies
import Networking
import SYCore

// MARK: - MatchesService

public protocol MatchesService {

    var matchesPublisher: AnyPublisher<Profile, Never> { get }

    func loadMatches() async
    func getMatches() async

}

// MARK: - DependencyKey

enum MatchesServiceKey: DependencyKey {

    public static var liveValue: any MatchesService = LiveMatchesService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var matchesService: any MatchesService {
        get { self[MatchesServiceKey.self] }
        set { self[MatchesServiceKey.self] = newValue }
    }

}

// MARK: - LiveMatchesService

actor LiveMatchesService: MatchesService {

    @Dependency(\.recommendationsNetworking) var recommendationsNetworking
    @Dependency(\.profilesService) var profilesService
    @Dependency(\.keychain) var keychain

    let matchesPublisher: AnyPublisher<Profile, Never>

    private let matchesSubject: CurrentValueSubject<Profile, Never>

    private var matches: [Profile] = []

    private var task: Bool = false
    private var isActive: Bool = false

    init() {
        matchesSubject = CurrentValueSubject<Profile, Never>(.init())
        matchesPublisher = matchesSubject.eraseToAnyPublisher()
    }

    func loadMatches() async {
        guard !task else {
            return
        }

        task = true

        if let _ = keychain.getToken(type: .refresh) {
            await getMatches()
        }
    }

    func getMatches() async {
        if let _ = keychain.getToken(type: .refresh) {
            if !isActive {
                isActive = true
                let response = await profilesService.getMatches()

                switch response {
                case let .success(response):
                    let profilesResponse = await getProfiles(ids: response)

                    switch profilesResponse {
                    case let .success(profiles):
                        let newMatch = profiles.first(where: { !matches.contains($0) })

                        if let newMatch {
                            matchesSubject.send(newMatch)
                        }

                    case .failure:
                        break
                    }

                    isActive = false
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                    await getMatches()

                case .failure:
                    isActive = false
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                    await getMatches()
                }
            }
        }
        else {
            isActive = false
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            await getMatches()
        }
    }

    private func getProfiles(ids: [String]) async -> Result<[Profile], BaseError> {
        let response = await withTaskGroup(
            of: Result<Profile, RequestError>.self,
            returning: Result<[Profile], RequestError>.self) { [profilesService] taskGroup in

                var profiles = [Profile]()

                ids.forEach { id in
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

        switch response {
        case .failure:
            return .failure(.error)

        case let .success(profiles):
            return .success(profiles)
        }
    }

}
