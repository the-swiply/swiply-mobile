import Foundation
import ComposableArchitecture
import Networking
import SYKeychain

// MARK: - AppStateManager

protocol AppStateManager {

    func getState() -> AppState
    func setAuthComplete()
    func setProfileCreationComplete()

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
    @Dependency(\.defaultAppStorage) var storage

    func getState() -> AppState {
        if !storage.bool(forKey: "isAuthComplete") {
            return .authorization
        }

        guard let _ = keychain.getToken(type: .refresh) else {
            return .authorization
        }

        guard let _ = keychain.getToken(type: .access) else {
            return .authorization
        }

        if storage.bool(forKey: "wasProfileCreated") {
            return .main
        }
        else {
            return .profileCreation
        }
    }

    func setAuthComplete() {
        storage.setValue(false, forKey: "isFirstRun")
    }

    func setProfileCreationComplete() {
        storage.setValue(true, forKey: "wasProfileCreated")
    }

}
