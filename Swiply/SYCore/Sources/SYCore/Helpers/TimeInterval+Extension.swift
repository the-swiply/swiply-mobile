import Foundation

public extension TimeInterval {

    var days: Int { Int(self) / (3600 * 24) }
    var hours: Int { (Int(self) / 3600) % 24 }
    var minutes: Int { Int(self) / 60 % 60 }
    var seconds: Int { Int(self) % 60 }

    var isLongerThanDay: Bool { days > 0 }

    func format() -> String {
        guard self >= 0 else { return "" }

        if isLongerThanDay {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM HH:mm"
            return String.from(Date().addingTimeInterval(self))
        }

        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

}
