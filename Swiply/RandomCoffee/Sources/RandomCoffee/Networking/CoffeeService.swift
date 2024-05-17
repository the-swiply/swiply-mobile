import Foundation
import ComposableArchitecture
import Networking
import SYCore

// MARK: - RandomCoffeeService

public protocol RandomCoffeeService {

    func getMeeting() async -> Result<Meeting, RequestError>
    func createMeeting(info: CreateMeeting) async -> Result<Meeting, RequestError>
    func deleteMeeting(id: String) async -> Result<EmptyResponse, RequestError>
    func updateMeeting(id: String, info: CreateMeeting) async -> Result<EmptyResponse, RequestError>
}

// MARK: - DependencyKey

enum RandomCoffeeServiceKey: DependencyKey {

    public static var liveValue: any RandomCoffeeService = LiveRandomCoffeeService()

}

// MARK: - DependencyValues

public extension DependencyValues {

    var coffeeService: any RandomCoffeeService {
        get { self[RandomCoffeeServiceKey.self] }
        set { self[RandomCoffeeServiceKey.self] = newValue }
    }

}


// MARK: - LiveChatService

class LiveRandomCoffeeService: RandomCoffeeService {
    
    private enum Constant {

        static let storageURL = URL.documentsDirectory.appending(component: "RandomCoffee")

    }
 
    @Dependency(\.coffeeNetworking) private var coffeeNetworking
    
    func getMeeting() async -> Result<Meeting, Networking.RequestError> {
        let getList = await coffeeNetworking.getMeetings()
        
        switch getList {
        case let .failure(error):
            return .failure(error)

        case let .success(allMeetings):
            guard let meeting = allMeetings.last else {
                return .failure( RequestError.unknown)
            }
            return .success(meeting)
        }
    }
    
    func createMeeting(info: CreateMeeting) async -> Result<Meeting, Networking.RequestError> {
        let createMeeting = await coffeeNetworking.createMeeting(info: info)
        
        switch createMeeting {
        case let .failure(error):
            return .failure(error)

        case let .success(meeting):
            return .success(meeting)
        }
    }
    
    func deleteMeeting(id: String) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        let deleteMeeting = await coffeeNetworking.deleteMeeting(id: id)
        
        switch deleteMeeting {
        case let .failure(error):
            return .failure(error)

        case let .success(meeting):
            return .success(meeting)
        }
    }
    
    func updateMeeting(id: String, info: CreateMeeting) async -> Result<Networking.EmptyResponse, Networking.RequestError> {
        let updateMeeting = await coffeeNetworking.updateMeeting(id: id, info: info)
        
        switch updateMeeting {
        case let .failure(error):
            return .failure(error)

        case let .success(meeting):
            return .success(meeting)
        }
    }
}

