import Foundation
import ComposableArchitecture
import Networking
import SYCore

// MARK: - ChatService

public protocol ChatService {
    func getChats() async -> Result<[ServerChat], RequestError>
    func sendMessage(message: MessageRequest) async -> Result<EmptyResponse, RequestError>
    func getNextMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], RequestError>
    func getPreviousMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], RequestError>
    func createChat(usersId: [String]) async -> Result<Int, RequestError>
    func leaveChat(chatId: Int) async -> Result<EmptyResponse, RequestError>
}

// MARK: - DependencyKey

enum ChatServiceKey: DependencyKey {

    public static var liveValue: any ChatService = LiveChatService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var chatService: any ChatService {
        get { self[ChatServiceKey.self] }
        set { self[ChatServiceKey.self] = newValue }
    }

}


// MARK: - LiveChatService

class LiveChatService: ChatService {

    private enum Constant {

        static let storageURL = URL.documentsDirectory.appending(component: "Chat")

    }
    
    @Dependency(\.chatServiceNetworking) private var chatServiceNetworking
    
    func getChats() async -> Result<[ServerChat], Networking.RequestError> {
        let getChatsResult = await chatServiceNetworking.getChats()
        
        switch getChatsResult {
        case let .success(info):
            return .success(info)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func sendMessage(message: MessageRequest) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        let sendMessageResult = await chatServiceNetworking.sendMessage(message: message)
        
        switch sendMessageResult {
        case let .success(info):
            return .success(info)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func getNextMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], Networking.RequestError> {
        let getNextMessagesResult = await chatServiceNetworking.getNextMessages(message: message)
        
        switch getNextMessagesResult {
        case let .success(info):
            return .success(info)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func getPreviousMessages(message: GetMessagesRequest) async -> Result<[ServerChatMessage], Networking.RequestError> {
        let getPreviousMessagesResult = await chatServiceNetworking.getPreviousMessages(message: message)
        
        switch getPreviousMessagesResult {
        case let .success(info):
            return .success(info)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func createChat(usersId: [String]) async -> Result<Int, Networking.RequestError> {
        let createChatResult = await chatServiceNetworking.createChat(usersId: usersId)
        
        switch createChatResult {
        case let .success(info):
            return .success(info)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func leaveChat(chatId: Int) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        let leaveChatResult = await chatServiceNetworking.leaveChat(chatId: chatId)
        
        switch leaveChatResult {
        case let .success(info):
            return .success(info)
        case let .failure(error):
            return .failure(error)
        }
    }
}

