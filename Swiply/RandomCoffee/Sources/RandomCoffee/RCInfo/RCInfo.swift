import SwiftUI
import ComposableArchitecture
import SYVisualKit

@Reducer
public struct RCInfo {
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
//    @Dependency(\.dismiss) var dismiss

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

