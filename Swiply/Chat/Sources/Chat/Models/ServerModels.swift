import Foundation

public struct ServerChat: Decodable {
    public let id: Int
    public let users: [String]
}

public struct ServerChatMessage: Decodable {
    public let id, from_id, content, send_time: String
    public let chat_id, id_in_chat: Int
    public let users: [String]
}
