import ComposableArchitecture
import SYKeychain

// MARK: - Endpoint

public protocol TokenizedEndpoint: Endpoint { }

public extension TokenizedEndpoint {

    var keychain: SYKeychain {
        DependencyValues.live.keychain
    }

    var header: [String: String]? {
        [
            "Authorization": "Bearer " + (keychain.getToken(type: .access) ?? "")
        ]
    }



}
