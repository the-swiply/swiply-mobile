import ComposableArchitecture

// MARK: - DependencyClient

@DependencyClient
public struct SYKeychain {

    public var setToken: (_ token: String, _ type: TokenType) -> Void
    public var getToken: (_ type: TokenType) -> String?

}

// MARK: - DependencyKey

extension SYKeychain: DependencyKey {

    public static var liveValue: SYKeychain {
        return SYKeychain(
            setToken: { token, type in
                SecureStorage.addToken(token, for: type.rawValue)
            },
            getToken: { type in
                SecureStorage.getToken(for: type.rawValue)
            }
        )
    }

}

// MARK: - DependencyValues

public extension DependencyValues {

  var keychain: SYKeychain {
    get { self[SYKeychain.self] }
    set { self[SYKeychain.self] = newValue }
  }

}
