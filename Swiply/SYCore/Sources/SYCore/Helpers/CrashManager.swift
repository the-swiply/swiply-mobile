import FirebaseCrashlytics

public final class CrashManager {
    
    public static let shared = CrashManager()
    
    public func setIsUserPremium(_ isPremium: Bool) {
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    
    public func addLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    public func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    private func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
}
