import SwiftUI
import SYCore

public struct Person: Identifiable, Equatable {
    public let id = UUID()
    public let email: String
    public var name: String
    public let age: Date
    public let gender: Gender
    public var interests: [Interest]
    public var town: String
    public var description: String
    public var images: [UIImage?]
    public var education: String = ""
    public var work: String = ""
    
    init(email: String, name: String, age: Date, gender: Gender, interests: [Interest], town: String, description: String, images: [UIImage?], education: String, work: String) {
        self.email = email
        self.name = name
        self.age = age
        self.gender = gender
        self.interests = interests
        self.town = town
        self.description = description
        self.images = images
        self.education = education
        self.work = work
    }
    
    init(email: String, name: String, age: Date, gender: Gender, interests: [Interest], town: String, description: String, images: [UIImage?]) {
        self.email = email
        self.name = name
        self.age = age
        self.gender = gender
        self.interests = interests
        self.town = town
        self.description = description
        self.images = images
    }
}


public struct UserID: Decodable {
    public let id: String
}

public extension Person {
    init(_ model: Profile) {
        
        var images = model.images.images.map {
            switch $0 {
            case let .image(image):
                return image
            case .loading:
                return UIImage(resource: .noPhoto)
            }
        }
        
        if images.isEmpty {
            images.append(UIImage(resource: .noPhoto))
        }
        
        self.init(
            email: model.email,
            name: model.name,
            age: model.age,
            gender: model.gender,
            interests: model.interests,
            town: model.town,
            description: model.description,
            images: images,
            education: model.education,
            work: model.work
        )
    }
    
    
    func toProfile(_ old: Profile) -> Profile {
        Profile(
            id: old.id,
            name: self.name,
            age: old.age,
            gender: old.gender, 
            interests: self.interests,
            town: self.town,
            description: self.description,
            email: old.email,
            images: LoadableImageCollection(images: self.images.map({
                if let img = $0 {
                    return .image(img)
                } else {
                    return .loading
                }
            })),
            education: self.education,
            work: self.work, 
            corporateMail: []
        )
    }
}

public struct CreatedProfile: Equatable {
    public var email: String
    public var name: String
    public var age: Date
    public var gender: Gender
    public var interests: [Interest]
    public var town: String
    public var description: String
    public var images: [UIImage?]
    public var education: String = ""
    public var work: String = ""
    
    public init(email: String, name: String, age: Date, gender: Gender, interests: [Interest], town: String, description: String, images: [UIImage?], education: String, work: String) {
        self.email = email
        self.name = name
        self.age = age
        self.gender = gender
        self.interests = interests
        self.town = town
        self.description = description
        self.images = images
        self.education = education
        self.work = work
    }
    
    public init() {
        self.email = "email@test.com"
        self.name = "name"
        self.age = Date()
        self.gender = .female
        self.interests = []
        self.town = "town"
        self.description = "description"
        self.images = []
        self.education = "education"
        self.work = "work"
    }
}

public extension Person {
    static let ann = Person(
        email: "userTestAna@",
        name: "Аня",
        age: Date(),
        gender: .female,
        interests: [],
        town: "Москва",
        description: "Очень люблю путешествовать и мечтаю объездить все страны мира. Учусь онлайн на ландшафтного дизайнера в Итальянском институте.  \n\nПоследнее время очень полюбился театр, ищу человека, который готов составить мне компанию) ",
        images: [UIImage(resource: .ann1), UIImage(resource: .ann2)]
    )

    static let kate = Person(
        email: "userTestKate@",
        name: "Екатерина",
        age: Date(),
        gender: .female,
        interests: [],
        town: "Москва",
        description: "В любой сложной жизненной ситуации остаюсь оптимисткой. \n\nВерю в людей и в то, что встречу здесь достойного человека, которому нужна любовь и поддержка. \n\nМужчине, которого полюблю, отдам всю свою заботу и нежность. Давай знакомиться!",
        images: [UIImage(resource: .kate)]
    )

    static let maria = Person(
        email: "userTestMaria@",
        name: "Мария",
        age: Date(),
        gender: .female,
        interests: [],
        town: "Москва",
        description: "Я мобильный разработчик! Обычно всех удивляет этот факт, а если этого мало, то я разрабатываю приложения как под iOS, так и под Android. Под Android только начинаю учиться, но мне нравится. \n\nСтараюсь вести здоровый образ жизни и часто езжу на велосипеде, это успокаивает. Если ты не готов кататься со мной на велосипеде или провести весь день на IT конференции, то даже не пиши)",
        images: [UIImage(resource: .maria), UIImage(resource: .night)]
    )


    static let daria = Person(
        email: "userTestDaria@",
        name: "Дарья",
        age: Date(),
        gender: .female,
        interests: [],
        town: "Москва",
        description: "Знаю 5 языков и знаю кухню 5 стран) Люблю животных и музыку, мечтаю открыть своё кафе с домашними животными.",
        images: [UIImage(resource: .daria)]
    )


    static let vera = Person(
        email: "userTestVera@",
        name: "Вероника",
        age: Date(),
        gender: .female,
        interests: [],
        town: "Москва",
        description: "Люблю готовить, особенно десерты, поэтому торт на день рождения обеспечен. Недавно уволилась с работы и ищу себя. \n\nУ меня есть две собаки, так что всё свободное время провожу с ними",
        images: [UIImage(resource: .vera)]
    )


    static let tima = Person(
        email: "userTestTim@",
        name: "Тимофей",
        age: Date(),
        gender: .male,
        interests: [],
        town: "Москва",
        description: "Учусь в лучшем вузе страны ВШЭ ФКН. Хочу найти друзей по интересам и отправиться в путешествие на несколько месяцев",
        images: [UIImage(resource: .tima)]
    )
}
