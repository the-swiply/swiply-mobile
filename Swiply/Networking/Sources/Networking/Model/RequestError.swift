
public enum RequestError: Error {

    case decode
    case invalidURL
    case noResponse
    case unexpectedResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown

    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"

        case .unauthorized:
            return "Session expired"
            
        default:
            return "Unknown error"
        }
    }

}
