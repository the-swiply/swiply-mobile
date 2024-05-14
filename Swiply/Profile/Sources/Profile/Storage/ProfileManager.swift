//
//  File.swift
//  
//ProfileStorage.swift ProfileManager.swift
//  Created by Ksenia Petrova on 12.05.2024.
//
//import Foundation
import ComposableArchitecture
//import Networking
import ProfilesService

// MARK: - AppStateManager

public protocol ProfileManager {

//    func getState() -> AppState
//    func setAuthComplete()
//    func setProfileCreationComplete()
//    func setUserId(id: String)
    func setUserId(id: String)
    func setProfileInfo(_ info: Person)
    func getUserId() -> String
//    func getProfileInfo()
    func clearAll()

}

// MARK: - DependencyKey

enum ProfileManagerKey: DependencyKey {

    public static var liveValue: any ProfileManager = LiveProfileManager()

}

// MARK: - DependencyValues

extension DependencyValues {

    public var profileManager: ProfileManager {
    get { self[ProfileManagerKey.self] }
    set { self[ProfileManagerKey.self] = newValue }
  }

}

// MARK: - AppStateManager

class LiveProfileManager: ProfileManager {
//    func setProfileInfo(_ info: Person) {
//        storage.setValue(info, forKey: "profile")
//    }
//    
//    func getProfileInfo() {
//        storage.object(forKey: "profile")
//    }
    
    @Shared(.inMemory("Person")) var user = Person.ann
    @Dependency(\.keychain) var keychain
    @Dependency(\.defaultAppStorage) var storage
    
    
    func setUserId(id: String) {
        storage.setValue(id, forKey: "userId")
    }
    
    func setProfileInfo(_ info: Person) {
        user = info
    }
//    
    func getUserId() -> String {
        storage.string(forKey: "userId") ?? ""
    }
    
//    func getProfileInfo() {
//
//    }
    
    func clearAll() {
        storage.removeObject(forKey: "userId")
    }

//    func getState() -> AppState {
//        return .authorization
//        if !storage.bool(forKey: "isAuthComplete") {
//            return .authorization
//        }
//
//        guard let _ = keychain.getToken(type: .refresh) else {
//            return .authorization
//        }
//
//        guard let _ = keychain.getToken(type: .access) else {
//            return .authorization
//        }
//
//        if storage.bool(forKey: "wasProfileCreated") {
//            return .main
//        }
//        else {
//            return .profileCreation
//        }
//    }
//
//    func setAuthComplete() {
//        storage.setValue(true, forKey: "isAuthComplete")
//    }
//
//    func setProfileCreationComplete() {
//        storage.setValue(true, forKey: "wasProfileCreated")
//    }
//    
//    func setUserId(id: String) {
//        storage.setValue(id, forKey: "userId")
//    }

}
