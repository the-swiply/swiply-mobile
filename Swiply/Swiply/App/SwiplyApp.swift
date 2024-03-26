import Foundation
import SwiftUI
import ComposableArchitecture

final class AppDelegate: NSObject, UIApplicationDelegate {

    let store = Store(initialState: Root.State()) {
        Root()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UIView.appearance().tintColor = .systemPink

        store.send(.appDelegate(.didFinishLaunching))
        return true
    }

}

@main
struct SwiplyApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView(store: appDelegate.store)
        }
    }

}
