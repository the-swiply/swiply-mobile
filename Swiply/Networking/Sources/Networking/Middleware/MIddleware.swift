// MARK: - Protocol

public protocol Middleware {

    func processRequest<T: Decodable>(_ request: Request) async -> Result<T, RequestError>

}
