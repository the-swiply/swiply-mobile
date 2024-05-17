import Foundation
import OSLog

public extension Logger {

    private static var subsystem = Bundle.main.bundleIdentifier ?? "Swiply"

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    
    /// All logs related to data such as decoding error, parsing issues, etc.
    static let data = Logger(subsystem: subsystem, category: "data")
    
    /// All logs related to services such as network calls, location, etc.
    static let services = Logger(subsystem: subsystem, category: "services")
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
        urlComponents.path = "/\(endpoint.pathPrefix)\(endpoint.path)"
        urlComponents.port = endpoint.port
        urlComponents.queryItems = endpoint.queryItems

        print(urlComponents.path)

        guard var url = urlComponents.url else {
            return .failure(.invalidURL)
        }

        endpoint.pathComponents.forEach { url.append(path: $0) }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.header
       
        
        if let body = endpoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [.withoutEscapingSlashes])
        } else if let jsonStr = endpoint.jsonStr {
            urlRequest.httpBody = Data(jsonStr.utf8)
        }
        
        Logger.services.log("curl: \(urlRequest.cURL())")
        Logger.services.log("Send request: \(endpoint.path)")
        
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
            


            Logger.services.log("Status code: \(response.statusCode) response: \(endpoint.path)")

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
                    Logger.data.error("EROR: decode")
                    return .failure(.decode)
                }
                
                return .success(decodedResponse)

            case 401:
                Logger.data.error("EROR: unauthorized")
                return .failure(.unauthorized)

            case 403:
                Logger.data.error("EROR: forbidden")
                return .failure(.forbidden)

            default:
                Logger.data.error("EROR: unexpectedStatusCode")
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
