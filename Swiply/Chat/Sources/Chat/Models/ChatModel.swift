import SwiftUI
import UserService

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


public extension ChatModel {
    
    static let chatSample = [
        ChatModel(
            person: Person.daria,
            messages: [
                Message("Привет, как дела?)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent),
                Message("Привет, хорошо. Как твои?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Тоже, погода хорошая не хочешь прогуляться?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent),
                Message("Давай", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("А у тебя есть домашние животные?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent),
                Message("Да, буквально сегодня привезла щенка домой)", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received),
                Message("Вау", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
                Message("Это классно", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
                Message("Бери его с собой на прогулку)", date: Date(timeIntervalSinceNow: -75000 * 3), type: .sent),
                Message("Договорились", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received),
                Message("Куда пойдём?", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received),
                Message("Давай в Парк Горького?", date: Date(timeIntervalSinceNow: -73000 * 3), type: .sent),
                Message("Хорошо", date: Date(timeIntervalSinceNow: -73000 * 3), type: .received),
            ],
            unreadMessage: true
        ),
        ChatModel(
            person: Person.ann,
            messages: [
                Message("Привет, я тоже хочу в путешествие! Куда отправимся?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
                Message("Привет)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent)//,
//                Message("Тоже, пойдём гулять?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
//                Message("Завтра", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
//                Message("Беру билеты в Москву))", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received),
//                Message("или взять тебе в Корею лучше?)", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received),
//                Message("Вау..", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
//                Message("Лучше ты приезжай", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent),
//                Message("Буду ждать тебя", date: Date(timeIntervalSinceNow: -75000 * 3), type: .received),
            ],
            unreadMessage: false
        )
    ]
}


public extension Matches {
    static let matchesSample = [
        Matches(
            person: Person.ann,
            isViewed: true
        ),
        Matches(
            person: Person.daria,
            isViewed: true
        ),
        
        Matches(
            person: Person.kate,
            isViewed: false
        ),
        
        Matches(
            person: Person.maria,
            isViewed: false
        ),
        
        Matches(
            person: Person.vera,
            isViewed: false
        )
    ]
}
