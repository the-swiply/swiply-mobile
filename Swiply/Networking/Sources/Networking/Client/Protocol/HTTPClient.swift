import Foundation
import OSLog

public extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier ?? "Swiply"

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    
    /// All logs related to data such as decoding error, parsing issues, etc.
    static let data = Logger(subsystem: subsystem, category: "data")
    
    /// All logs related to services such as network calls, location, etc.
    static let services = Logger(subsystem: subsystem, category: "services")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}


public protocol HTTPClient {
    
    static func sendRequest<T: Decodable>(_ request: Request) async -> Result<T, RequestError>
    static func sendRequestWithMiddleware<T: Decodable>(
        _ request: Request,
        middleware: Middleware
    ) async -> Result<T, RequestError>

}

public extension HTTPClient {

    static func sendRequest<T: Decodable>(
        _ request: Request
    ) async -> Result<T, RequestError> {
        let endpoint = request.endpoint

        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port

        guard var url = urlComponents.url else {
            return .failure(.invalidURL)
        }

        endpoint.pathComponents.forEach { url.append(path: $0) }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        Logger.services.log("CURL: \n \(urlRequest.cURL())")
        do {
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true

            switch request.requestTimeout {
            case let .finite(interval):
                config.timeoutIntervalForResource = interval

            case .infinite:
                config.timeoutIntervalForResource = 30000000
            }

            let (data, response) = try await URLSession(configuration: config).data(for: urlRequest, delegate: nil)

            guard let response = response as? HTTPURLResponse else {
                Logger.services.log("EROR: noResponse")
                return .failure(.noResponse)
            }

            Logger.data.log("Status code: \(response.statusCode)")
            
            switch response.statusCode {
            case 200...299:
                if T.self == EmptyResponse.self {
                    guard let emptyResponse = EmptyResponse() as? T else {
                        return .failure(.unexpectedResponse)
                    }

                    Logger.data.log("Success: emptyResponse")
                    return .success(emptyResponse)
                }
                
                if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                    Logger.data.log("Response: \(JSONString)")
                }

                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    Logger.data.log("EROR: decode")
                    return .failure(.decode)
                }
                
                return .success(decodedResponse)

            case 401:
                return .failure(.unauthorized)

            case 403:
                return .failure(.forbidden)

            default:
                return .failure(.unexpectedStatusCode)
            }
        }
        catch {
            return .failure(.unknown)
        }
    }

}

public extension HTTPClient {

    static func sendRequestWithMiddleware<T: Decodable>(
        _ request: Request,
        middleware: Middleware
    ) async -> Result<T, RequestError> {
        await middleware.processRequest(request)
    }

}


public extension URLRequest {
    
    func cURL() -> String {
        let cURL = "curl -f"
        let method = "-X \(self.httpMethod ?? "GET")"
        let url = url.flatMap { "--url '\($0.absoluteString)'" }
        
        let header = self.allHTTPHeaderFields?
            .map { "-H '\($0): \($1)'" }
            .joined(separator: " ")
        
        let data: String?
        if let httpBody, !httpBody.isEmpty {
            if let bodyString = String(data: httpBody, encoding: .utf8) { // json and plain text
                let escaped = bodyString
                    .replacingOccurrences(of: "'", with: "'\\''")
                data = "--data '\(escaped)'"
            } else { // Binary data
                let hexString = httpBody
                    .map { String(format: "%02X", $0) }
                    .joined()
                data = #"--data "$(echo '\#(hexString)' | xxd -p -r)""#
            }
        } else {
            data = nil
        }
        
        return [cURL, method, url, header, data]
            .compactMap { $0 }
            .joined(separator: " ")
    }
    
}
