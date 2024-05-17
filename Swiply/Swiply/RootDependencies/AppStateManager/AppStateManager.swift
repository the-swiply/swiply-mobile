import Foundation
import ComposableArchitecture
import Networking
import SYKeychain

// MARK: - AppStateManager

protocol AppStateManager {

    func getState() async -> AppState
    func setProfileCreationComplete()
    func setUserId(id: String)
    func clearAll()

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
    @Dependency(\.updateTokenService.refresh) var refresh

    func getState() async -> AppState {
        guard let token = keychain.getToken(type: .refresh) else {
            return .authorization
        }

        let refreshResponse = await refresh(token)

        switch refreshResponse {
        case let .success(response):
            keychain.setToken(token: response.accessToken, type: .access)
            keychain.setToken(token: response.refreshToken, type: .refresh)

        case .failure:
            return .authorization
        }

        return .main

//        if storage.bool(forKey: "wasProfileCreated") {
//            return .main
//        }
//        else {
//            return .profileCreation
//        }
    }

    func setProfileCreationComplete() {
        storage.setValue(true, forKey: "wasProfileCreated")
    }
    
    func setUserId(id: String) {
        storage.setValue(id, forKey: "userId")
    }
    
    func clearAll() {
        keychain.deleteToken(type: .access)
        keychain.deleteToken(type: .refresh)
        storage.removeObject(forKey: "userId")
    }
}
