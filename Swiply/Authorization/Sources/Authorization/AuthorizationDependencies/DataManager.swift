import ComposableArchitecture

// MARK: - AuthorizarionData

struct AuthorizarionData {

    var email: String

}

// MARK: - DataManager

protocol DataManager {

    func getEmail() -> String
    func setEmail(_ email: String) -> Void

}

// MARK: - DependencyKey

private enum DataManagerKey: DependencyKey {

    static var liveValue: any DataManager = LiveDataManager(authorizarionData: .init(email: ""))
}

// MARK: - LiveDataManager

class LiveDataManager: DataManager {

    var authorizarionData: AuthorizarionData

    init(authorizarionData: AuthorizarionData) {
        self.authorizarionData = authorizarionData
    }

    func getEmail() -> String {
        authorizarionData.email
    }

    func setEmail(_ email: String) -> Void {
        authorizarionData.email = email
    }

}

// MARK: - DependencyValues

extension DependencyValues {

  var dataManager: any DataManager {
    get { self[DataManagerKey.self] }
    set { self[DataManagerKey.self] = newValue }
  }

}
