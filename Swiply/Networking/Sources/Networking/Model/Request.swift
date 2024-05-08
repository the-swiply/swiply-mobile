import Foundation

// MARK: - Request

public struct Request {

    var requestTimeout: RequestTimeout
    var endpoint: Endpoint

    public init(requestTimeout: RequestTimeout = .finite(15), endpoint: Endpoint) {
        self.requestTimeout = requestTimeout
        self.endpoint = endpoint
    }
}

// MARK: - RequestTimeout

public enum RequestTimeout {

    case infinite
    case finite(TimeInterval)
    
}
