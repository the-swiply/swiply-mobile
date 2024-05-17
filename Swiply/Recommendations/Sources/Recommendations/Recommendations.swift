import ComposableArchitecture
import SYCore
import SYVisualKit
import Foundation
import CardInformation

@Reducer
public struct Recommendations {

    @Reducer(state: .equatable)
    public enum Path {
        case info(CardInformation)
    }

    @ObservableState
    public struct State: Equatable {
        var profiles: [Profile] = []
        var swipeAction: SwipeAction<String>?

        var path = StackState<Path.State>()

        public init() { }

    }

    public enum Action {
        case onAppear
        case backButtonTapped
        case likeButtonTapped(UUID)
        case dislikeButtonTapped(UUID)
        case nextPhotoButtonTapped
        case onTapCenter(Profile)
        case updateProfiles([Profile])
        case loadProfiles
        case filter(age: ClosedRange<Int>, gender: ProfileGender)
        case handleMatch
        case makeBackSwipe(UUID)
        case path(StackAction<Path.State, Path.Action>)
    }

    @Dependency(\.recommendationsService) var recommendationsService
    @Dependency(\.profilesService) var profilesService
    @Dependency(\.matchesService) var matchesService


    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                .publisher {
                    return recommendationsService
                        .publisher
                        .map { .updateProfiles($0) }
                },
                .publisher {
                    return matchesService
                        .matchesPublisher
                        .map { _ in .handleMatch }
                },
                .run { send in
                    await matchesService.loadMatches()
                }
                )

            case let .updateProfiles(profiles):
                state.profiles = profiles

                if profiles.count <= 5 {
                    return .send(.loadProfiles)
                }

                return .none

            case .loadProfiles:
                return .run { send in
                    await recommendationsService.loadProfiles(number: 10)
                }

            case .backButtonTapped:
                return .run { send in
                    if let id = await recommendationsService.lastProfile()?.id {
                        await send(.makeBackSwipe(id))
                    }
                }

            case .makeBackSwipe(let id):
                state.swipeAction = .toCenter(id: id.uuidString.lowercased())
                return .none


            case let .likeButtonTapped(id):
                state.swipeAction = .right(id: id.uuidString.lowercased())

                return .run { send in
                    await recommendationsService.likeProfile(id: id)
                }

            case let .dislikeButtonTapped(id):
                state.swipeAction = .left(id: id.uuidString.lowercased())

                return .run { send in
                    await recommendationsService.dislikeProfile(id: id)
                }

            case .nextPhotoButtonTapped:
                return .none

            case let .onTapCenter(profile):
                state.path.append(.info(.init(profile: profile)))
                return .none

            case let .filter(age, gender):
                return .run { send in
                    await recommendationsService.filterProfiles(age: age, gender: gender)
                }

            case .handleMatch:
                print("New Match")
                return .none

            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
