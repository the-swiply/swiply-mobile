// MARK: - Protocol

public protocol Middleware {

    func processRequest<T: Decodable>(endpoint: Endpoint) async -> Result<T, RequestError>

}
