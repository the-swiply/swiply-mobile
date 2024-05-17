import Dependencies
import Networking
import SYCore
import Foundation

// MARK: - RandomCoffeeServiceNetworking

public protocol CoffeeServiceNetworking {
    func getMeetings() async -> Result<[Meeting], RequestError>
    func getMeeting(id: String) async -> Result<[Meeting], RequestError>
    func createMeeting(info: CreateMeeting) async -> Result<Meeting, RequestError>
    func deleteMeeting(id: String) async -> Result<EmptyResponse, RequestError>
    func updateMeeting(id: String, info: CreateMeeting) async -> Result<EmptyResponse, RequestError>
}

// MARK: - DependencyKey

enum CoffeeServiceNetworkingKey: DependencyKey {

    public static var liveValue: any CoffeeServiceNetworking = LiveCoffeeServiceNetworking()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var coffeeNetworking: any CoffeeServiceNetworking {
        get { self[CoffeeServiceNetworkingKey.self] }
        set { self[CoffeeServiceNetworkingKey.self] = newValue }
    }
}


// MARK: - LiveProfilesServiceNetworking

class LiveCoffeeServiceNetworking: LiveTokenUpdatableClient, CoffeeServiceNetworking {
    func getMeetings() async -> Result<[Meeting], Networking.RequestError> {
        await sendRequest(.getListMeeting)
    }
    
    func getMeeting(id: String) async -> Result<[Meeting], Networking.RequestError> {
        await sendRequest(.getMeeting(id: id))
    }
    
    func createMeeting(info: CreateMeeting) async -> Result<Meeting, Networking.RequestError> {
        await sendRequest(.createMeeting(info: info))
    }
    
    func deleteMeeting(id: String) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        await sendRequest(.deleteMeeting(id: id))
    }
    
    func updateMeeting(id: String, info: CreateMeeting) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        await sendRequest(.updateMeeting(id: id, info: info))
    }
}

// MARK: - Endpoint

enum CoffeeServiceNetworkingEndpoint: TokenizedEndpoint {

    case getMeeting(id: String)
    case getListMeeting
    case createMeeting(info: CreateMeeting)
    case deleteMeeting(id: String)
    case updateMeeting(id: String, info: CreateMeeting)

    var pathPrefix: String {
        #if DEBUG

        return ""

        #endif

        return "randomcoffee"
    }


    var path: String {
        switch self {
   
        case .getMeeting:
            "/v1/meeting"
        case .getListMeeting:
            "/v1/meetings"
            
        case .createMeeting:
            "/v1/meeting/create"
            
        case .deleteMeeting:
            "/v1/meeting/delete"
            
        case .updateMeeting:
            "/v1/meeting/update"
        }
    }

    var pathComponents: [String] {
        switch self {
            
        case let .getMeeting(id):
            [id]
            
        case .getListMeeting, .createMeeting, .deleteMeeting, .updateMeeting:
            []
    
        }
    }

    var method: HTTPMethod {
        switch self {
   
        case .getMeeting, .getListMeeting:
                .get
        case .createMeeting, .deleteMeeting,.updateMeeting:
                .post
        }
    }

    var body: [String : Codable]? {
        switch self {
       
        case .getMeeting, .getListMeeting:
            return nil
            
        case let.createMeeting(info):
            return [
                "start":  DateFormatter.server.string(from: info.start),
                "end": DateFormatter.server.string(from: info.end),
                "organization_id": info.organizationId
            ]
            
        case let .deleteMeeting(id):
            return ["id": id]
            
        case let .updateMeeting(id, info):
            return [
                "id": id,
                "start":  DateFormatter.server.string(from: info.start),
                "end": DateFormatter.server.string(from: info.end),
                "organization_id": info.organizationId
            ]
        }
            
    }

    #if DEBUG

    var port: Int? {
        18079
    }

    #endif
  
}

// MARK: - Extension Request

private extension Request {
    
    static func getMeeting(id: String) -> Self {
        .init(endpoint: CoffeeServiceNetworkingEndpoint.getMeeting(id: id))
    }
    
    static var getListMeeting: Self {
        .init(endpoint: CoffeeServiceNetworkingEndpoint.getListMeeting)
    }

    static func createMeeting(info: CreateMeeting) -> Self {
        .init(endpoint: CoffeeServiceNetworkingEndpoint.createMeeting(info: info))
    }
    
    static func deleteMeeting(id: String) -> Self {
        .init(endpoint: CoffeeServiceNetworkingEndpoint.deleteMeeting(id: id))
    }
    
    static func updateMeeting(id: String, info: CreateMeeting) -> Self {
        .init(endpoint: CoffeeServiceNetworkingEndpoint.updateMeeting(id: id, info: info))
    }
}
