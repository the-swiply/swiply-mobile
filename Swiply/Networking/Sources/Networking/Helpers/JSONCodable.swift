import Foundation

// MARK: - Protocol

public protocol JSONEncodable {

    func encode() throws -> Data

}

public protocol JSONDecodable {

    static func decode(from data: Data) throws -> Self

}

public typealias JSONCodable = JSONDecodable & JSONEncodable

// MARK: - Dictionary Conformance

extension Dictionary: JSONEncodable where Key: Encodable, Value: Encodable { }
extension Dictionary: JSONDecodable where Key: Decodable, Value: Decodable { }

// MARK: - Array Conformance

extension Array: JSONEncodable where Element: Encodable { }
extension Array: JSONDecodable where Element: Decodable { }

// MARK: - Set Conformance

extension Set: JSONEncodable where Element: Encodable { }
extension Set: JSONDecodable where Element: Decodable { }

// MARK: - Optional Conformance

extension Optional: JSONEncodable where Wrapped: Encodable { }
extension Optional: JSONDecodable where Wrapped: Decodable { }

// MARK: - Extension

extension JSONDecodable where Self: Decodable {

    public static func decode(from data: Data) throws -> Self {
        let result = try JSONDecoder().decode(Self.self, from: data)
        return result
    }

}

extension Data {

    public func decode<T>() throws -> T where T: JSONDecodable {
        return try T.decode(from: self)
    }

}


extension JSONEncodable where Self: Encodable {

    public func encode() throws -> Data {
        let result = try JSONEncoder().encode(self)
        return result
    }

}
