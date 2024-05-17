import Dependencies
import Networking
import SYCore
import Foundation

// MARK: - ChatServiceNetworking

public protocol ChatServiceNetworking {

    func getChats() async -> Result<[ServerChat], RequestError>
    func sendMessage(message: MessageRequest) async -> Result<EmptyResponse, RequestError>
    func getNextMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], RequestError>
    func getPreviousMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], RequestError>
    func createChat(usersId: [String]) async -> Result<Int, RequestError>
    func leaveChat(chatId: Int) async -> Result<EmptyResponse, RequestError>
}

// MARK: - DependencyKey

enum ChatServiceNetworkingKey: DependencyKey {

    public static var liveValue: any ChatServiceNetworking = LiveChatServiceNetworking()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var chatServiceNetworking: any ChatServiceNetworking {
        get { self[ChatServiceNetworkingKey.self] }
        set { self[ChatServiceNetworkingKey.self] = newValue }
    }

}


// MARK: - LiveProfilesServiceNetworking

class LiveChatServiceNetworking: LiveTokenUpdatableClient, ChatServiceNetworking {
    func getChats() async -> Result<[ServerChat], Networking.RequestError> {
        await sendRequest(.getChats)
    }
    
    func sendMessage(message: MessageRequest) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        await sendRequest(.sendMessage(message: message))
    }
    
    func getNextMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], Networking.RequestError> {
        await sendRequest(.getNextMessages(message: message))
    }
    
    func getPreviousMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], Networking.RequestError> {
        await sendRequest(.getPreviousMessages(message: message))
    }
    
    func createChat(usersId: [String]) async -> Result<Int, Networking.RequestError> {
        await sendRequest(.createChat(ids: usersId))
    }
    
    func leaveChat(chatId: Int) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        await sendRequest(.leaveChat(id: chatId))
    }
}

// MARK: - Endpoint

enum ChatServiceNetworkingEndpoint: TokenizedEndpoint {

    case getChats
    case sendMessage(MessageRequest)
    case getNextMessages(GetMessagesRequest)
    case getPreviousMessages(GetMessagesRequest)
    case createChat([String])
    case leaveChat(id: Int)

    var path: String {
        switch self {
   
        case .getChats:
            "/v1/chats"
            
        case .sendMessage:
            "/v1/message/send"
            
        case .getNextMessages:
            "/v1/message/get-next"
            
        case .getPreviousMessages:
            "/v1/message/get-previous"
            
        case .createChat:
            "/v1/chat/create"
            
        case .leaveChat:
            "/v1/chat/leave"
        }
    }

    var pathComponents: [String] {
        switch self {
            
        case .getChats,
                .sendMessage,
                .getNextMessages,
                .getPreviousMessages,
                .createChat:
            []
   
        case let .leaveChat(id):
            [id.description]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getChats,
            .getNextMessages,
            .getPreviousMessages:
            .get
        case .sendMessage,
            .createChat,
            .leaveChat:
            .post
    
        }
    }

    var body: [String : Codable]? {
        switch self {
        case .getChats, .leaveChat:
            return nil
            
        case let .sendMessage(message):
            return [
                "chat_id": message.id,
                "content": message.message
            ]
            
        case let .getNextMessages(request):
            return [
                "chat_id": request.chatId,
                "starting_from": request.startingFrom,
                "limit": request.limit
                ]
        case let .getPreviousMessages(request):
            return [
                "chat_id": request.chatId,
                "starting_from": request.startingFrom,
                "limit": request.limit
                ]
        case let .createChat(chats):
            return [
                "members": chats
                ]
        }
            
    }

    #if DEBUG

    var port: Int? {
        18082
    }

    #endif
  
}

// MARK: - Extension Request

private extension Request {
    
    static var getChats: Self {
        .init(endpoint: ChatServiceNetworkingEndpoint.getChats)
    }
    
    static func sendMessage(message: MessageRequest) -> Self {
        .init(endpoint: ChatServiceNetworkingEndpoint.sendMessage(message))
    }
    
    static func getNextMessages(message: GetMessagesRequest) -> Self {
        .init(endpoint: ChatServiceNetworkingEndpoint.getNextMessages(message))
    }
    
    static func getPreviousMessages(message: GetMessagesRequest) -> Self {
        .init(endpoint: ChatServiceNetworkingEndpoint.getPreviousMessages(message))
    }
    
    static func createChat(ids: [String]) -> Self {
        .init(endpoint: ChatServiceNetworkingEndpoint.createChat(ids))
    }
    
    static func leaveChat(id: Int) -> Self {
        .init(endpoint: ChatServiceNetworkingEndpoint.leaveChat(id: id))
    }
}


public struct MessageRequest {
    let id: Int
    let message: String
}


public struct GetMessagesRequest {
    let chatId, startingFrom, limit: Int
}
