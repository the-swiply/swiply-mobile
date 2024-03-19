import Foundation
import Security

final class SecureStorage {

    enum KeychainError: Error {

        case itemAlreadyExist
        case itemNotFound
        case errorStatus(String?)

        init(status: OSStatus) {
            switch status {
            case errSecDuplicateItem:
                self = .itemAlreadyExist
            case errSecItemNotFound:
                self = .itemNotFound
            default:
                let message = SecCopyErrorMessageString(status, nil) as String?
                self = .errorStatus(message)
            }
        }

    }

    static func addItem(query: [CFString: Any]) throws {
        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }

    static func findItem(query: [CFString: Any]) throws -> [CFString: Any]? {
        var query = query
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue

        var searchResult: AnyObject?

        let status = withUnsafeMutablePointer(to: &searchResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        if status != errSecSuccess {
            throw KeychainError(status: status)
        } else {
            return searchResult as? [CFString: Any]
        }
    }

    static func updateItem(query: [CFString: Any], attributesToUpdate: [CFString: Any]) throws {
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }

    static func deleteItem(query: [CFString: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }

}

extension SecureStorage {

    static func addToken(_ token: String, for key: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key
        query[kSecValueData] = token.data(using: .utf8)

        do {
            try addItem(query: query)
        } catch {
            return
        }
    }

    static func updateToken(_ token: String, for key: String) {
        guard let _ = getToken(for: token) else {
            addToken(token, for: key)
            return
        }

        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key

        var attributesToUpdate: [CFString: Any] = [:]
        attributesToUpdate[kSecValueData] = token.data(using: .utf8)

        do {
            try updateItem(query: query, attributesToUpdate: attributesToUpdate)
        } catch {
            return
        }
    }

    static func getToken(for key: String) -> String? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key

        var result: [CFString: Any]?

        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }

        if let data = result?[kSecValueData] as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    static func deleteToken(for key: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = key

        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }

}
