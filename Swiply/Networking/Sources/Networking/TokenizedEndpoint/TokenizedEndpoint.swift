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
            "access": keychain.getToken(type: .access) ?? "",
            "refresh": keychain.getToken(type: .refresh) ?? ""
        ]
    }



}
