
import ComposableArchitecture
import ProfilesService

// MARK: - AppStateManager

public protocol ProfileManager {

    func setUserId(id: String)
    func setProfileInfo(_ info: Person)
    func getUserId() -> String
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
    
    @Shared(.inMemory("Person")) var user = Person.ann
    @Dependency(\.keychain) var keychain
    @Dependency(\.defaultAppStorage) var storage
    
    
    func setUserId(id: String) {
        storage.setValue(id, forKey: "userId")
    }
    
    func setProfileInfo(_ info: Person) {
        user = info
    }

    func getUserId() -> String {
        storage.string(forKey: "userId") ?? ""
    }
    
    func clearAll() {
        storage.removeObject(forKey: "userId")
    }
}
