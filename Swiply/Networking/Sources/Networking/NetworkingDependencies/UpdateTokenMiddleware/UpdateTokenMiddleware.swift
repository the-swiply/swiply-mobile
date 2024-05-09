import SYKeychain
import Dependencies

// MARK: - UpdateTokenMiddleware

public protocol UpdateTokenMiddleware: Middleware { }

// MARK: - DependencyKey

enum UpdateTokenMiddlewareKey: DependencyKey {

    public static var liveValue: any UpdateTokenMiddleware = LiveUpdateTokenMiddleware()
    
}

// MARK: - DependencyValues

public extension DependencyValues {

    var updateTokenMiddleware: any UpdateTokenMiddleware {
        get { self[UpdateTokenMiddlewareKey.self] }
        set { self[UpdateTokenMiddlewareKey.self] = newValue }
    }

}


// MARK: - LiveUpdateTokenMiddleware

class LiveUpdateTokenMiddleware: UpdateTokenMiddleware, ForbiddenErrorNotifier {

    var forbiddenErrorHandlers: [() async -> Void] = []

    @Dependency(\.keychain) var keychain
    @Dependency(\.updateTokenService.refresh) var refresh

    func processRequest<T: Decodable>(_ request: Request) async -> Result<T, RequestError> {
        let result: Result<T, RequestError> = await HTTPClientImpl.sendRequest(request)

        switch result {
        case .success:
            return result

        case let .failure(error):
            switch error {
            case .unauthorized:
                guard let token = keychain.getToken(.refresh) else {
                    return .failure(.unknown)
                }

                let tokenUpdateResult = await refresh(token)

                switch tokenUpdateResult {
                case let .success(response):
                    keychain.setToken(token: response.accessToken, type: .access)
                    keychain.setToken(token: response.refreshToken, type: .refresh)

                    return await processRequest(request)

                case let .failure(error):
                    return .failure(error)
                }

            case .forbidden:
                forbiddenErrorHandlers.forEach { handler in
                    Task {
                        await handler()
                    }
                }

                return result

            default:
                return result
            }
        }
    }

    func add(handler: @escaping () async -> Void) {
        forbiddenErrorHandlers.append(handler)
    }

}
