import ComposableArchitecture
import Networking

// MARK: - DependencyClient

@DependencyClient
struct AuthService: HTTPClient {

    var sendCode: (_ email: String) async -> (Result<EmptyResponse, RequestError>) = { _ in .success(EmptyResponse()) }
    var login: (_ email: String, _ code: String) async ->
        (Result<EmptyResponse, RequestError>) = { _, _ in .success(EmptyResponse()) }

}

// MARK: - DependencyKey

extension AuthService: DependencyKey {

    static var liveValue: AuthService {
        let sendCode: (_ email: String) async -> (Result<EmptyResponse, RequestError>) = { email in
            await sendRequest(endpoint: AuthEndpoint.sendCode(email: email))
        }

        let login: (_ email: String, _ code: String) async -> (Result<EmptyResponse, RequestError>) = { email, code in
            await sendRequest(endpoint: AuthEndpoint.login(email: email, code: code))
        }

        return AuthService(
            sendCode: sendCode,
            login: login
        )
    }

}

// MARK: - DependencyValues

extension DependencyValues {

  var authService: AuthService {
    get { self[AuthService.self] }
    set { self[AuthService.self] = newValue }
  }

}

// MARK: - Endpoint

enum AuthEndpoint: Endpoint {

    case sendCode(email: String)
    case login(email: String, code: String)

    var path: String { 
        switch self {
        case .sendCode:
            "/v1/send-authorization-code"

        case .login:
            "/v1/login"
        }

    }

    var method: HTTPMethod { .post }

    var header: [String : String]? { [:] }

    var body: [String : String]? {
        switch self {
        case let .sendCode(email):
            ["email": email]

        case let .login(email, code):
            ["email": email, "code": code]
        }
    }

    #if DEBUG

    var host: String {
        "192.168.1.34"
//        "127.0.0.1."
    }

    var port: Int? {
        18081
    }

    #endif

}
