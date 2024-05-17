import SYKeychain
import Dependencies
import Combine

// MARK: - UpdateTokenMiddleware

public protocol UpdateTokenMiddleware: Middleware, ForbiddenErrorNotifier { }

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

class LiveUpdateTokenMiddleware: UpdateTokenMiddleware {

    var publisher: AnyPublisher<Void, Never> {
        forbiddenErrorSubject.eraseToAnyPublisher()
    }

    private var forbiddenErrorSubject: CurrentValueSubject<Void, Never> = .init(())

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
                    switch error {
                    case .forbidden:
                        forbiddenErrorSubject.send(())

                        return .failure(error)

                    default:
                        return .failure(error)
                    }
                }

            case .forbidden:
                forbiddenErrorSubject.send(())

                return result

            default:
                return result
            }
        }
    }

}
