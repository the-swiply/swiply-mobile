import SwiftUI

public struct ChatModel: Identifiable, Equatable {
    public var id: UUID { person.id }
    let person: Person
    var messages: [Message]
    var unreadMessage: Bool
}

public struct Matches: Identifiable, Equatable {
    public var id: UUID { person.id }
    public let person: Person
    var isViewed: Bool
}

public struct Person: Identifiable, Equatable {
    public let id = UUID()
    let name: String
    let imgString: Image
    var isViewed: Bool
}

public struct Message: Identifiable, Equatable {
    public let id = UUID()
    let date: Date
    let text: String
    var isViewed: Bool
    let type: MessageType
    
    enum MessageType {
        case sent
        case received
    }
    
    init(_ text: String, date: Date, type: MessageType) {
        self.date = date
        self.text = text
        self.isViewed = false
        self.type = type
    }
    
    init(_ text: String, type: MessageType) {
        self.date = Date()
        self.text = text
        self.isViewed = false
        self.type = type
    }
    
    init(_ text: String, type: MessageType, isViewed: Bool) {
        self.date = Date()
        self.text = text
        self.isViewed = isViewed
        self.type = type
    }
}

public extension Person {
    static let jungkook = Person(name: "Jungkook", imgString: Image(.jungkook), isViewed: false)
    static let suga = Person(name: "Suga", imgString: Image(.suga), isViewed: false)
    static let ui = Person(name: "UI", imgString: Image(.ui), isViewed: false)
    static let te =  Person(name: "Te", imgString: Image(.techen), isViewed: false)
    static let jimin = Person(name: "Jimin", imgString: Image(.jimin), isViewed: false)
}

public extension ChatModel {
    
    static let chatSample = [
        ChatModel(
            person: Person.jungkook,
            messages: [
                Message("Привет, как дела?)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Привет, хорошо. Как твои?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent),
                Message("Тоже, пойдём гулять?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Завтра", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Беру билеты в Москву))", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("или взять тебе в Корею лучше?)", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received),
                Message("Вау..", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
                Message("Лучше ты приезжай", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
                Message("Хорошо)", date: Date(timeIntervalSinceNow: -75000 * 3), type: .received),
            ],
            unreadMessage: true
        ),
        ChatModel(
            person: Person.suga,
            messages: [
                Message("Привет, как дела?)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Привет, хорошо. Как твои?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent),
                Message("Тоже, пойдём гулять?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Завтра", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Беру билеты в Москву))", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("или взять тебе в Корею лучше?)", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received),
                Message("Вау..", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
                Message("Лучше ты приезжай", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
                Message("Буду ждать тебя", date: Date(timeIntervalSinceNow: -75000 * 3), type: .received),
            ],
            unreadMessage: true
        )
    ]
}


public extension Matches {
    static let matchesSample = [
        Matches(
            person: Person.jungkook,
            isViewed: true
        ),
        Matches(
            person: Person.ui,
            isViewed: true
        ),
        
        Matches(
            person: Person.suga,
            isViewed: false
        ),
        
        Matches(
            person: Person.te,
            isViewed: false
        ),
        
        Matches(
            person: Person.jimin,
            isViewed: false
        )
    ]
}
