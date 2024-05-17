import Foundation

public protocol Endpoint {

    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var pathPrefix: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var pathComponents: [String] { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: Codable]? { get }
    var jsonStr: String? { get }

}

public extension Endpoint {

    var scheme: String {
        "http"
    }

    var host: String {
        #if DEBUG

        return debugHost

        #endif

        return "api.swiply.ru"
    }

    var port: Int? {
        nil
    }

    var queryItems: [URLQueryItem]?  {
        nil
    }

    var pathComponents: [String] {
        []
    }
    
    var jsonStr: String? {
        nil
    }

}
