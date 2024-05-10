// MARK: - LoginResponse

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
