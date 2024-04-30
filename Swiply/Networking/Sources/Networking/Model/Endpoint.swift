
public protocol Endpoint {

    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }

}

public extension Endpoint {

    var scheme: String {
        return "http"
    }

    var host: String {
//        return "api.swiply.ru"
        return "localhost:18081"
    }
    
    var port: Int? {
        nil
    }
}
