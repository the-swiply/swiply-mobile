import ComposableArchitecture
import SwiftUI
import ProfilesService

@Reducer
public struct FormCreationRoot {
    
    @Reducer(state: .equatable)
    public enum Path {
        case birthdayView(BirthdayFeature)
        case genderView(GenderFeature)
        case interestsInput(InterestsFeature)
        case cityInput(InfoInputFeature)
        case imageView(ImageFeature)
        case biographyView(InfoInputFeature)
        case education(InfoInputFeature)
        case work(InfoInputFeature)
    }

    @ObservableState
    public struct State: Equatable {

        var path = StackState<Path.State>()
        var welcome = InfoInputFeature.State()

        public init(path: StackState<Path.State> = StackState<Path.State>(),
                    welcome: InfoInputFeature.State = InfoInputFeature.State()) {
            self.path = path
            self.welcome = welcome
        }

    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case welcome(InfoInputFeature.Action)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            InfoInputFeature()
        }
        Reduce { state, action in
            switch action {
            case let .welcome(action):
                switch action {
                case .continueButtonTapped:
                    state.path.append(.birthdayView(BirthdayFeature.State()))
                    return .none
                default:
                    return .none
                }
                
            case .path(.element(_, .birthdayView(.continueButtonTapped))):
                state.path.append(.genderView(GenderFeature.State()))
                return .none

        
            case .path(.element(_, .genderView(.continueButtonTapped))):
                state.path.append(.interestsInput(InterestsFeature.State()))
                return .none
                
            case .path(.element(_, .interestsInput(.continueButtonTapped))):
                state.path.append(.cityInput(InfoInputFeature.State()))
                return .none
                
            case .path(.element(_, .cityInput(.continueButtonTapped))):
                state.path.append(.imageView(ImageFeature.State()))
                return .none
                
            case .path(.element(_, .imageView(.continueButtonTapped))):
                state.path.append(.biographyView(InfoInputFeature.State()))
                return .none
                
            case .path(.element(_, .biographyView(.continueButtonTapped))):
                state.path.append(.education(InfoInputFeature.State()))
                return .none
                
            case .path(.element(_, .education(.continueButtonTapped))):
                state.path.append(.work(InfoInputFeature.State()))
                return .none
                
            case .path:
                return .none
            }
     
        }
        .forEach(\.path, action: \.path)
    }

}
