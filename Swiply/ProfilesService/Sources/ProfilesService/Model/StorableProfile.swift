import Foundation
import SYCore

// MARK: - StorableProfile

struct StorableProfile: Codable {
    let id: UUID
    let name: String
    let age: Int
    let gender: Gender
    let interests: [String]
    let town: String
    let description: String
    let images: [String]
}
