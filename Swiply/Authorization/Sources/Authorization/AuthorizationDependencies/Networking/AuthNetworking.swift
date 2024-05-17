import ComposableArchitecture
import Networking

// MARK: - DependencyClient

@DependencyClient
struct AuthNetworking: HTTPClient {

    var sendCode: (_ email: String) async -> Result<EmptyResponse, RequestError> = { _ in .success(EmptyResponse()) }
    var login: (_ email: String, _ code: String) async ->
        Result<LoginResponse, RequestError> = { _, _ in .success(.init(accessToken: "", refreshToken: "")) }

}

// MARK: - DependencyKey

extension AuthNetworking: DependencyKey {

    static var liveValue: AuthNetworking {
        let sendCode: (_ email: String) async -> Result<EmptyResponse, RequestError> = { email in
            await sendRequest(.sendCode(email: email))
        }

        let login: (_ email: String, _ code: String) async -> Result<LoginResponse, RequestError> = { email, code in
            await sendRequest(.login(email: email, code: code))
        }

        return AuthNetworking(
            sendCode: sendCode,
            login: login
        )
    }

}

// MARK: - DependencyValues

extension DependencyValues {

  var authNetworking: AuthNetworking {
    get { self[AuthNetworking.self] }
    set { self[AuthNetworking.self] = newValue }
  }

}

// MARK: - Endpoint

enum AuthEndpoint: Endpoint {

    case sendCode(email: String)
    case login(email: String, code: String)

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "user"
    }

    var path: String {
        switch self {
        case .sendCode:
            return "/v1/send-authorization-code"

        case .login:
            return "/v1/login"
        }

    }

    var method: HTTPMethod { .post }

    var header: [String : String]? { [:] }

    var body: [String : Codable]? {
        switch self {
        case let .sendCode(email):
            ["email": email]

        case let .login(email, code):
            ["email": email, "code": code]
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

    static func sendCode(email: String) -> Self {
        .init(endpoint: AuthEndpoint.sendCode(email: email))
    }

    static func login(email: String, code: String) -> Self {
        .init(endpoint: AuthEndpoint.login(email: email, code: code))
    }

}
