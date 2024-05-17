import Foundation

// MARK: - RandomCoffeeError

public enum RandomCoffeeError {
    case alreadyInProgress
    case networkError
    case noOrganization
    case none
    
    var description: String {
        switch self {
        case .alreadyInProgress:
            "Вы не можете изменить данные для «Random Coffee» так как распределение уже началось"
        case .networkError:
            "Не удалось загрузить данные"
        case .noOrganization:
            "Вы не можете участвовать в «Random Coffee» так как у вас нет подтвержденных корпоративных почт."
        case .none:
            "Всё отлично! Хорошего дня"
        }
    }
}
