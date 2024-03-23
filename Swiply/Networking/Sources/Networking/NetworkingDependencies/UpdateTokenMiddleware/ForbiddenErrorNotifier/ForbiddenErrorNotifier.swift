import ComposableArchitecture

// MARK: - ForbiddenErrorNotifier

public protocol ForbiddenErrorNotifier {

    func add(handler: @escaping () async  -> Void)

}

// MARK: - DependencyKey

enum ForbiddenErrorNotifierKey: DependencyKey {

    public static var liveValue: any ForbiddenErrorNotifier = LiveUpdateTokenMiddleware()
}

// MARK: - DependencyValues

public extension DependencyValues {

  var forbiddenErrorNotifier: any ForbiddenErrorNotifier {
    get { self[ForbiddenErrorNotifierKey.self] }
    set { self[ForbiddenErrorNotifierKey.self] = newValue }
  }

}
