import Foundation

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
                return .failure(.noResponse)
            }

            switch response.statusCode {
            case 200...299:
                if T.self == EmptyResponse.self {
                    guard let emptyResponse = EmptyResponse() as? T else {
                        return .failure(.unexpectedResponse)
                    }

                    return .success(emptyResponse)
                }

                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
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
