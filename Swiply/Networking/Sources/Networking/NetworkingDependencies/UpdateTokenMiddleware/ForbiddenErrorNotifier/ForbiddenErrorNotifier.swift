import ComposableArchitecture
import Combine

// MARK: - ForbiddenErrorNotifier

public protocol ForbiddenErrorNotifier {

    var publisher: AnyPublisher<Void, Never> { get }

}

// MARK: - DependencyKey

enum ForbiddenErrorNotifierKey: DependencyKey {

    public static var liveValue: any ForbiddenErrorNotifier = DependencyValues.live.updateTokenMiddleware
}

// MARK: - DependencyValues

public extension DependencyValues {

  var forbiddenErrorNotifier: any ForbiddenErrorNotifier {
    get { self[ForbiddenErrorNotifierKey.self] }
    set { self[ForbiddenErrorNotifierKey.self] = newValue }
  }

}
