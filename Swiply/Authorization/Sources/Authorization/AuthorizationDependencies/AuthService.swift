import ComposableArchitecture
import Networking

// MARK: - DependencyClient

@DependencyClient
struct AuthService: HTTPClient {

    var sendCode: (_ email: String) async -> (Result<EmptyResponse, RequestError>) = { _ in .success(EmptyResponse()) }
    var verifyCode: (_ email: String, _ code: String) async -> 
        (Result<EmptyResponse, RequestError>) = { _, _ in .success(EmptyResponse()) }

}

// MARK: - DependencyKey

extension AuthService: DependencyKey {

    static var liveValue: AuthService {
        let sendCode: (_ email: String) async -> (Result<EmptyResponse, RequestError>) = { email in
            await sendRequest(endpoint: AuthEndpoint.sendEmail(email: email))
        }

        let verifyCode: (_ email: String, _ code: String) async -> (Result<EmptyResponse, RequestError>) = { email, code in
            await sendRequest(endpoint: AuthEndpoint.verifyCode(email: email, code: code))
        }

        return AuthService(
            sendCode: sendCode,
            verifyCode: verifyCode
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

    case sendEmail(email: String)
    case verifyCode(email: String, code: String)

    var path: String { 
        switch self {
        case .sendEmail:
            "/v1/send-authorization-code"

        case .verifyCode:
            "/v1/send-authorization-code"
        }

    }

    var method: HTTPMethod { .post }

    var header: [String : String]? { [:] }

    var body: [String : String]? {
        switch self {
        case let .sendEmail(email):
            ["email": email]

        case let .verifyCode(email, code):
            ["email": email, "code": code]
        }
    }

}
