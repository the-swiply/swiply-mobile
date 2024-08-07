import ComposableArchitecture

// MARK: - DependencyClient

@DependencyClient
public struct UpdateTokenService: HTTPClient {

    public var refresh: (_ token: String) async -> (Result<UpdateTokenResponse, RequestError>) = { _ in .success(.init(accessToken: "", refreshToken: "")) }

}

// MARK: - DependencyKey

extension UpdateTokenService: DependencyKey {

    public static var liveValue: UpdateTokenService {
        return UpdateTokenService(
            refresh: { token in
                await sendRequest(.refresh(token: token))
            }
        )
    }

}

// MARK: - DependencyValues

extension DependencyValues {

  public var updateTokenService: UpdateTokenService {
    get { self[UpdateTokenService.self] }
    set { self[UpdateTokenService.self] = newValue }
  }

}

// MARK: - Endpoint

enum UpdateTokenEndpoint: Endpoint {

    case refresh(token: String)

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "user"
    }

    var path: String {
        switch self {
        case .refresh:
            "v1/refresh"
        }
    }

    var method: HTTPMethod { .post }

    var header: [String : String]? { [:] }

    var body: [String : Codable]? {
        switch self {
        case let .refresh(token):
            ["refreshToken": token]
        }
    }

    #if DEBUG

    var port: Int? {
        18081
    }

    #endif

}

// MARK: - Extension Request

private extension Request {

    static func refresh(token: String) -> Self {
        .init(requestTimeout: .infinite, endpoint: UpdateTokenEndpoint.refresh(token: token))
    }

}
