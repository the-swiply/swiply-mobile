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
        var features = Home.State()

        public init(selectedTab: Tab = Tab.recommendations) {
            self.selectedTab = selectedTab
        }
    }

    public enum Action {
        case tabSelected(Tab)
        case features(Home.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            case .features:
                return .none
            }
        }
        Scope(state: \.features, action: \.features) {
            Home()
        }
    }

}

