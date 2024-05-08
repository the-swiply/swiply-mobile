import SYKeychain
import Dependencies

// MARK: - TokenUpdatableClient

public protocol TokenUpdatableClient {

    func sendRequest<T: Decodable>(_ request: Request) async -> Result<T, RequestError>

}

// MARK: - DependencyKey

enum TokenUpdatableClientKey: DependencyKey {

    public static var liveValue: any TokenUpdatableClient = LiveTokenUpdatableClient()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var tokenUpdatableClient: any TokenUpdatableClient {
        get { self[TokenUpdatableClientKey.self] }
        set { self[TokenUpdatableClientKey.self] = newValue }
    }

}


// MARK: - LiveTokenUpdatableClient

open class LiveTokenUpdatableClient: TokenUpdatableClient {

    @Dependency(\.updateTokenMiddleware) var middleware

    public func sendRequest<T>(_ request: Request) async -> Result<T, RequestError> where T : Decodable {
        await HTTPClientImpl.sendRequestWithMiddleware(request, middleware: middleware)
    }

    public init() { }

}
