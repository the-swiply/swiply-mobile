import Foundation

public extension Encodable {
    func toJSONStr() -> String {
        var jsonString: String?
        
        do {
            let encodedData = try JSONEncoder().encode(self)
            jsonString = String(data: encodedData, encoding: .utf8)
        } catch {
            return ""
        }
        
        return jsonString ?? ""
    }
}
