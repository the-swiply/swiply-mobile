import ComposableArchitecture
import ProfilesService
import SYCore

// MARK: - CoffeeManager

public protocol CoffeeManager {


    func didShowCoffee()
    func shouldShow() -> Bool
}

// MARK: - DependencyKey

enum CoffeeManagerKey: DependencyKey {

    public static var liveValue: any CoffeeManager = LiveCoffeeManager()

}

// MARK: - DependencyValues

extension DependencyValues {

    public var coffeeManager: CoffeeManager {
    get { self[CoffeeManagerKey.self] }
    set { self[CoffeeManagerKey.self] = newValue }
  }

}

// MARK: - AppStateManager

class LiveCoffeeManager: CoffeeManager {

    @Dependency(\.defaultAppStorage) var storage
    
    func didShowCoffee() {
        storage.set(true, forKey: "random_coffee")
    }
    
    func shouldShow() -> Bool {
        storage.bool(forKey: "random_coffee")
    }
}


