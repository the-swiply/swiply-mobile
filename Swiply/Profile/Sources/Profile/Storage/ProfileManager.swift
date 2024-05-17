import ComposableArchitecture
import ProfilesService
import SYCore

// MARK: - ProfileManager

public protocol ProfileManager {

    func setUserId(id: String)
    func setProfileInfo(_ info: Profile)
    func getUserId() -> String
    func clearAll()
    func setMatchNotification(_ isOn: Bool)
    func setMessageNotification(_ isOn: Bool)
    func setLikeNotification(_ isOn: Bool)
    func setMeetingNotification(_ isOn: Bool)
    func isMatchOn() -> Bool
    func isMessageOn() -> Bool
    func isLikeOn() -> Bool
    func isMeetingOn() -> Bool
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

// MARK: - LiveProfileManager

class LiveProfileManager: ProfileManager {

    @Shared(.inMemory("Person")) var user = Profile()
    @Dependency(\.defaultAppStorage) var storage
    
    func setUserId(id: String) {
        storage.setValue(id, forKey: "userId")
    }
    
    func setProfileInfo(_ info: Profile) {
        user = info
    }

    func getUserId() -> String {
        storage.string(forKey: "userId") ?? ""
    }
    
    func clearAll() {
        user = Profile()
        storage.removeObject(forKey: "userId")
    }
    
    func setMatchNotification(_ isOn: Bool) {
        storage.setValue(isOn, forKey: Notification.match.rawValue)
    }
    
    func setMessageNotification(_ isOn: Bool) {
        storage.setValue(isOn, forKey: Notification.message.rawValue)
    }
    
    func setLikeNotification(_ isOn: Bool) {
        storage.setValue(isOn, forKey: Notification.like.rawValue)
    }
    
    func setMeetingNotification(_ isOn: Bool) {
        storage.setValue(isOn, forKey: Notification.meeting.rawValue)
    }
    
    func isMatchOn() -> Bool {
        storage.bool(forKey: Notification.match.rawValue)
    }
    
    func isMessageOn() -> Bool {
        storage.bool(forKey: Notification.message.rawValue)
    }
    
    func isLikeOn() -> Bool {
        storage.bool(forKey: Notification.like.rawValue)
    }
    
    func isMeetingOn() -> Bool {
        storage.bool(forKey: Notification.meeting.rawValue)
    }
    
    enum Notification: String {
        case match = "matchNotification"
        case message = "messageNotification"
        case like = "likeNotification"
        case meeting = "meetingNotification"
    }
}


