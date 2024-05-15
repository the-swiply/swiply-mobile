import ComposableArchitecture
import SYCore
import SYVisualKit

@Reducer
public struct Recommendations {

    @ObservableState
    public struct State: Equatable {
        var profiles: [Profile] = []
        var swipeAction: SwipeAction<String>?

        public init() { }

    }

    public enum Action: Equatable {
        case onAppear
        case backButtonTapped
        case likeButtonTapped
        case dislikeButtonTapped
        case nextPhotoButtonTapped
        case onTapCenter
    }

    @Dependency(\.recommendationsService) var recommendationsService
    @Dependency(\.profilesService) var profilesService

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
//                    await recommendationsService.loadProfiles(number: 10)
                }

            case .backButtonTapped:
                return .none

            case .likeButtonTapped:
                guard let profile = state.profiles.first else {
                    return .none
                }

                state.swipeAction = .right(id: profile.id.uuidString)
                return .none

            case .dislikeButtonTapped:
                guard let profile = state.profiles.first else {
                    return .none
                }

                state.swipeAction = .left(id: profile.id.uuidString)
                return .none

            case .nextPhotoButtonTapped:
                return .none

            case .onTapCenter:
                return .none
            }
        }
    }

}
