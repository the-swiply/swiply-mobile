import Foundation

public protocol HTTPClient {
    
    static func sendRequest<T: Decodable>(endpoint: Endpoint) async -> Result<T, RequestError>

}

public extension HTTPClient {

    static func sendRequest<T: Decodable>(
        endpoint: Endpoint
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path

        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)

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

            default:
                return .failure(.unexpectedStatusCode)
            }
        }
        catch {
            return .failure(.unknown)
        }
    }

}
