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
        case imageView(ImageFeature)
        case nameInput(InfoInputReducer)
    }

    @ObservableState
    public struct State: Equatable {

        var path = StackState<Path.State>()
        var welcome = viewKFeature.State()

        public init(path: StackState<Path.State> = StackState<Path.State>(),
                    welcome: viewKFeature.State = viewKFeature.State()) {
            self.path = path
            self.welcome = welcome
        }

    }

    public enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case welcome(viewKFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.welcome, action: \.welcome) {
            viewKFeature()
             
    
        }
        Reduce { state, action in
            switch action {
            case let .welcome(action):
                if action == .continueButtonTapped {
                    state.path.append(.nameInput(InfoInputReducer.State()))
                }
                return .none
            case .path(.element(_, .nameInput(.continueButtonTapped))):
                state.path.append(.birthdayView(BirthdayFeature.State()))
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
                
            case .path(.element(_, .biographyView(.continueButtonTapped))):
                state.path.append(.imageView(ImageFeature.State()))
                return .none
            case .path:
                return .none
            }
     
        }
        .forEach(\.path, action: \.path)
    }

}

@Reducer
public struct viewKFeature {
    
    public struct State: Equatable {

        
        public init() {}
    }
    
    public enum Action: Equatable {
        case continueButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .continueButtonTapped:
                return .none
            }
        }
    }
    
    public init() {}
}



struct viewK: View {
    @Bindable var store: StoreOf<viewKFeature>
    var body: some View {
        HStack {
            
        }.onAppear(perform: {
            store.send(.continueButtonTapped)
        })
    }
}
