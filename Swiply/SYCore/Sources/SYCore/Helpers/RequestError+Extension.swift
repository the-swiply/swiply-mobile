import Networking

public extension Result where Failure == RequestError {

    func eraseToBaseError() -> Result<Success, BaseError> {
        switch self {
        case let .success(value):
            .success(value)

        case .failure:
            .failure(.error)
        }
    }

}
