import Foundation
import ComposableArchitecture
import Networking
import SYKeychain

// MARK: - AppStateManager

protocol AppStateManager {

    func getState() -> AppState
    func setState(_ state: AppState) -> Void

}

// MARK: - DependencyKey

enum AppStateManagerKey: DependencyKey {

    public static var liveValue: any AppStateManager = LiveAppStateManager()

}

// MARK: - DependencyValues

extension DependencyValues {

  var appStateManager: AppStateManager {
    get { self[AppStateManagerKey.self] }
    set { self[AppStateManagerKey.self] = newValue }
  }

}

// MARK: - AppStateManager

class LiveAppStateManager: AppStateManager {

    @Dependency(\.keychain) var keychain

    func getState() -> AppState {
        return .authorization
        guard let refresh = keychain.getToken(type: .refresh) else {
            return .authorization
        }

        guard let access = keychain.getToken(type: .access) else {
            return .authorization
        }

        let defaults = UserDefaults.standard

        if defaults.bool(forKey: "wasProfileCreated") {
            return .main
        }
        else {
            return .profileCreation
        }
    }
    
    func setState(_ state: AppState) {
        let defaults = UserDefaults.standard

        switch state {
        case .authorization:
            break

        case .profileCreation:
            defaults.setValue(false, forKey: "wasProfileCreated")

        case .main:
            defaults.setValue(true, forKey: "wasProfileCreated")
        }
    }
    
}
