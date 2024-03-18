import ComposableArchitecture
import SwiftUI

@Reducer

public struct FormCreationRoot {
    
    @Reducer(state: .equatable)
    public enum Path {
        case birthdayView(BirthdayFeature)
        case genderView(GenderFeature)
        case interestsInput(InterestsReducer)
        case cityInput(InfoInputReducer)
        case biographyView(InfoInputReducer)
    
    }

    @ObservableState
    public struct State: Equatable {

        var path = StackState<Path.State>()
        var welcome = InfoInputReducer.State()

        public init(path: StackState<Path.State> = StackState<Path.State>(),
                    welcome: InfoInputReducer.State = InfoInputReducer.State()) {
            self.path = path
            self.welcome = welcome
        }

    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case welcome(InfoInputReducer.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            InfoInputReducer()
        }
        Reduce { state, action in
            switch action {
            case let .welcome(action):
                if action == .continueButtonTapped {
                    state.path.append(.birthdayView(BirthdayFeature.State()))
                }
                return .none
                
            case .path(.element(_, .birthdayView(.continueButtonTapped))):
                state.path.append(.genderView(GenderFeature.State()))
                return .none

        
            case .path(.element(_, .genderView(.continueButtonTapped))):
                state.path.append(.interestsInput(InterestsReducer.State()))
                return .none
                
            case .path(.element(_, .interestsInput(.continueButtonTapped))):
                state.path.append(.cityInput(InfoInputReducer.State()))
                return .none
                
            case .path(.element(_, .cityInput(.continueButtonTapped))):
                state.path.append(.biographyView(InfoInputReducer.State()))
                return .none
                
            case .path:
                return .none
            }
     
        }
        .forEach(\.path, action: \.path)
    }

}
