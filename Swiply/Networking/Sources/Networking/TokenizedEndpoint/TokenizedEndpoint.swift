import ComposableArchitecture
import SYKeychain

// MARK: - Endpoint

protocol TokenizedEndpoint: Endpoint { }

extension TokenizedEndpoint {

    var keychain: SYKeychain {
        DependencyValues.live.keychain
    }

    var header: [String: String]? {
        [
            "Authorization": keychain.getToken(type: .access) ?? ""
        ]
    }



}
