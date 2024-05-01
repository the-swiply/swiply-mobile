import SwiftUI

public struct Person: Identifiable, Equatable {
    public let id = UUID()
    public var name: String
    public let age: Int
    public let gender: Gender
    public var interests: [String]
    public var town: String
    public var description: String
    public var images: [UIImage?]
    public var education: String = ""
    public var work: String = ""
}

public enum Gender {
    case male
    case female
    case none
    
    public var name: String {
        switch self {
        case .male:
            return "Мужской"
        case .female:
            return "Женский"
        case .none:
            return ""
        }
    }
}

public extension Person {
    static let ann = Person(
        name: "Аня",
        age: 19,
        gender: .female,
        interests: ["тeaтp", "ландшафтный дизайн", "путешествия"],
        town: "Москва",
        description: "Очень люблю путешествовать и мечтаю объездить все страны мира. Учусь онлайн на ландшафтного дизайнера в Итальянском институте.  \n\nПоследнее время очень полюбился театр, ищу человека, который готов составить мне компанию) ",
        images: [UIImage(resource: .ann1), UIImage(resource: .ann2)]
    )
   
    static let kate = Person(
        name: "Екатерина",
        age: 22,
        gender: .female,
        interests: ["танцы", "восточные танцы", "медитации", "йога" ,"фотография"],
        town: "Москва",
        description: "В любой сложной жизненной ситуации остаюсь оптимисткой. \n\nВерю в людей и в то, что встречу здесь достойного человека, которому нужна любовь и поддержка. \n\nМужчине, которого полюблю, отдам всю свою заботу и нежность. Давай знакомиться!",
        images: [UIImage(resource: .kate)]
    )

    static let maria = Person(
        name: "Мария",
        age: 20,
        gender: .female,
        interests: ["ios" ,"android", "здоровый образ жизни", "it", "велосипед"],
        town: "Москва",
        description: "Я мобильный разработчик! Обычно всех удивляет этот факт, а если этого мало, то я разрабатываю приложения как под iOS, так и под Android. Под Android только начинаю учиться, но мне нравится. \n\nСтараюсь вести здоровый образ жизни и часто езжу на велосипеде, это успокаивает. Если ты не готов кататься со мной на велосипеде или провести весь день на IT конференции, то даже не пиши)",
        images: [UIImage(resource: .maria), UIImage(resource: .night)]
    )
    

    static let daria = Person(
        name: "Дарья",
        age: 25,
        gender: .female,
        interests: ["иностранные языки", "кулинария" ,"животные" ,"музыка", "тату"],
        town: "Москва",
        description: "Знаю 5 языков и знаю кухню 5 стран) Люблю животных и музыку, мечтаю открыть своё кафе с домашними животными.",
        images: [UIImage(resource: .daria)]
    )
    
 
    static let vera = Person(
        name: "Вероника",
        age: 26,
        gender: .female,
        interests: ["стендап", "пицца", "кулинария" ,"животные"],
        town: "Москва",
        description: "Люблю готовить, особенно десерты, поэтому торт на день рождения обеспечен. Недавно уволилась с работы и ищу себя. \n\nУ меня есть две собаки, так что всё свободное время провожу с ними",
        images: [UIImage(resource: .vera)]
    )
    
    
    static let tima = Person(
        name: "Тимофей",
        age: 21,
        gender: .male,
        interests: ["стендап", "путешествия", "it"],
        town: "Москва",
        description: "Учусь в лучшем вузе страны ВШЭ ФКН. Хочу найти друзей по интересам и отправиться в путешествие на несколько месяцев",
        images: [UIImage(resource: .tima)]
    )
    
    
    
}
