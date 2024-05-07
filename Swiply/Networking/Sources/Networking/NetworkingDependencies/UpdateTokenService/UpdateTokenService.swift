import ComposableArchitecture

// MARK: - DependencyClient

@DependencyClient
struct UpdateTokenService: HTTPClient {

    var refresh: (_ token: String) async -> (Result<UpdateTokenResponse, RequestError>) = { _ in .success(.init(accessToken: "", refreshToken: "")) }

}

// MARK: - DependencyKey

extension UpdateTokenService: DependencyKey {

    static var liveValue: UpdateTokenService {
        return UpdateTokenService(
            refresh: { token in
                await sendRequest(endpoint: UpdateTokenEndpoint.refresh(token: token))
            }
        )
    }

}

// MARK: - DependencyValues

extension DependencyValues {

  var updateTokenService: UpdateTokenService {
    get { self[UpdateTokenService.self] }
    set { self[UpdateTokenService.self] = newValue }
  }

}

// MARK: - Endpoint

enum UpdateTokenEndpoint: Endpoint {

    case refresh(token: String)

    var path: String {
        switch self {
        case .refresh:
            "/v1/refresh"
        }
    }

    var method: HTTPMethod { .post }

    var header: [String : String]? { [:] }

    var body: [String : String]? {
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
