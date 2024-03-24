import ComposableArchitecture
import SwiftUI

@Reducer
public struct MainRoot {

    public enum Tab {
        case features
        case likes
        case recommendations
        case chat
        case profile
    }

    @ObservableState
    public struct State: Equatable {
        var selectedTab: Tab

        public init(selectedTab: Tab = Tab.recommendations) {
            self.selectedTab = selectedTab
        }
    }

    public enum Action {
        case tabSelected(Tab)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            }
        }
    }

}

