import SwiftUI

public extension String {

    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }

        return nil
    }

}

public extension String {

    static func from(_ date: Date, timeZone: TimeZone? = nil) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0) ?? .current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        return String(format: "%02i:%02i", hour, minute)
    }
}
