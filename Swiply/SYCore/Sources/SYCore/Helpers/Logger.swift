import OSLog

public extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier ?? "Swiply"

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    
    /// All logs related to data such as decoding error, parsing issues, etc.
    static let data = Logger(subsystem: subsystem, category: "data")
    
    /// All logs related to services such as network calls, location, etc.
    static let services = Logger(subsystem: subsystem, category: "services")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}
