import SwiftUI
import UserService


public enum ChatOptions: Identifiable, Equatable {
    case personal(PersonalChatModel)
    case multiUser(MultiUserChatModel)
    
    public var id: UUID {
        switch self {
        case let .personal(chat):
            return chat.id
        case let .multiUser(chat):
            return chat.id
        }
    }
}

public struct MultiUserChatModel: Identifiable, Equatable {
    public var id: UUID = UUID()
    var title: String
    var description: String
    var image: UIImage
    var messages: [Message]
    var unreadMessage: Bool
}


public struct PersonalChatModel: Identifiable, Equatable {
    public var id: UUID { person.id }
    let person: Person
    var messages: [Message]
    var unreadMessage: Bool
    var isMuted:Bool = false
}

public struct Matches: Identifiable, Equatable {
    public var id: UUID { person.id }
    public let person: Person
    var isViewed: Bool
}


public struct Message: Identifiable, Equatable {
    public let id = UUID()
    let person: Person
    let date: Date
    let text: String
    var isViewed: Bool
    let type: MessageType
    
    enum MessageType {
        case sent
        case received
    }
    
    init(_ text: String, date: Date, type: MessageType, person: Person) {
        self.date = date
        self.text = text
        self.isViewed = false
        self.type = type
        self.person = person
    }
    
    init(_ text: String, type: MessageType, person: Person) {
        self.date = Date()
        self.text = text
        self.isViewed = false
        self.type = type
        self.person = person
    }
    
    init(_ text: String, type: MessageType, isViewed: Bool, person: Person) {
        self.date = Date()
        self.text = text
        self.isViewed = isViewed
        self.type = type
        self.person = person
    }
}

extension ChatOptions {
    static let chatSample: [ChatOptions] = PersonalChatModel.chatSample.map { .personal($0) }
}

public extension MultiUserChatModel {
    static let chatSample = [
        MultiUserChatModel(
            title: "Книжный клуб",
            description: "",
            image: UIImage(resource: .books2),
            messages:  [
                Message("Привет, недавно прочитала книгу задача трёх тел. Не хотите обсудить?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent, person: .tima),
                Message("Привет, я как раз заканчиваю читать", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .kate),
                Message("И я тоже", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .maria),
                Message("В воскрессенье встретимся обсудим?", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent, person: .tima),
                Message("Да", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received, person: .kate),
                Message("Я тоже согласна", date: Date(timeIntervalSinceNow: -75000 * 3), type: .sent, person: .maria),
                Message("Можно потом в парке устроить просмотр сериала по этой книге!", date: Date(timeIntervalSinceNow: -75000 * 3), type: .sent, person: .maria),
                Message("Отличная идея!", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received, person: .kate)
//                Message("Договорились", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .vera),
//                Message("Куда пойдём?", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .kate),
//                Message("Давай в Парк Горького?", date: Date(timeIntervalSinceNow: -73000 * 3), type: .sent, person: .tima),
//                Message("Куда пойдём?", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .kate),
                ],
            unreadMessage: true
            )
//        ),
//        MultiUserChatModel(
//            title: "Меро2",
//            description: "",
//            image: UIImage(resource: .ui),
//            messages:  [
//                Message("Привет, как дела?)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent, person: .tima),
//                Message("Привет, хорошо. Как твои?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .kate),
//                Message("Тоже, погода хорошая не хочешь прогуляться?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .maria),
//                Message("Вау", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent, person: .tima),
//                Message("Это классно", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received, person: .kate),
//                Message("Бери его с собой на прогулку)", date: Date(timeIntervalSinceNow: -75000 * 3), type: .sent, person: .tima),
//                Message("Договорились", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .vera),
//                Message("Куда пойдём?", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .kate),
//                Message("Давай в Парк Горького?", date: Date(timeIntervalSinceNow: -73000 * 3), type: .sent, person: .tima),
//                ],
//            unreadMessage: true
//        )
    ]
}

public extension PersonalChatModel {
    
    static let chatSample = [
        PersonalChatModel(
            person: Person.daria,
            messages: [
                Message("Привет, как дела?)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent, person: .daria),
                Message("Привет, хорошо. Как твои?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .daria),
                Message("Тоже, погода хорошая не хочешь прогуляться?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent, person: .daria),
                Message("Давай", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .daria),
                Message("А у тебя есть домашние животные?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent, person: .daria),
                Message("Да, буквально сегодня привезла щенка домой)", date: Date(timeIntervalSinceNow: -76000 * 3), type: .received, person: .daria),
                Message("Вау", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent, person: .daria),
                Message("Это классно", date: Date(timeIntervalSinceNow: -76000 * 3), type: .sent, person: .daria),
                Message("Бери его с собой на прогулку)", date: Date(timeIntervalSinceNow: -75000 * 3), type: .sent, person: .daria),
                Message("Договорились", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .daria),
                Message("Куда пойдём?", date: Date(timeIntervalSinceNow: -74000 * 3), type: .received, person: .daria),
                Message("Давай в Парк Горького?", date: Date(timeIntervalSinceNow: -73000 * 3), type: .sent, person: .daria),
                Message("Хорошо", date: Date(timeIntervalSinceNow: -73000 * 3), type: .received, person: .daria),
            ],
            unreadMessage: true
        ),
        PersonalChatModel(
            person: Person.ann,
            messages: [
                Message("Привет, я тоже хочу в путешествие! Куда отправимся?", date: Date(timeIntervalSinceNow: -78000 * 3), type: .received, person: .ann),
                Message("Привет)", date: Date(timeIntervalSinceNow: -78000 * 3), type: .sent, person: .ann)//,
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
