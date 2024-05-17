// MARK: - SwipeAction

public enum SwipeAction<ID: Equatable>: Equatable {
    case left(id: ID)
    case right(id: ID)

    public var id: ID {
        switch self {
        case .left(let id):
            id
        case .right(let id):
            id
        }
    }
}
