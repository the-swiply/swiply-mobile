import Foundation

public extension DateFormatter {
    static let iSO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    static let server: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}


public extension Date {
    
    func getAge() -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to:  Date())
        return ageComponents.year ?? 0
    }
}
