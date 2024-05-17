import ComposableArchitecture
import StoreKit
import OSLog

@Reducer
public struct PaywallFeature {

    @ObservableState
    public struct State: Equatable {
        let num: Int = 0
        var products: [Product] = []
        var selectedId = "Swiply.monthly"
        @Presents var alert: AlertState<Action.Alert>?
        @Shared(.inMemory("hasSubscription")) var hasSubscription = false
    }

    public enum Action: Equatable {
        case continueTapped(String)
        case onAppear
        case update(products: [Product])
        case registerPublisher
        case handlePurchase
        case cancelTapped
        case alert(PresentationAction<Alert>)
        case backTapped
        case changeId(String)

        public enum Alert: Equatable {
          case confirm
        }
    }


    public init() { }

    @Dependency(\.purchaseManager) var purchaseManager
    @Dependency(\.dismiss) var dismiss

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .continueTapped(id):
                return .run { send in
                    let products = await purchaseManager.getProducts()

                    if let product = products.first(where: { $0.id == id }) {
                        try await purchaseManager.purchase(product)
                    }
                }

            case .onAppear:
                return .run { send in
                    await send(.registerPublisher)
                    await purchaseManager.observeTransactionUpdates()
                    try await purchaseManager.loadProducts()
                    let products = await purchaseManager.getProducts()
                    Logger.services.debug("\(products.description)")
                    await send(.update(products: products))
                }

            case .changeId(let id):
                state.selectedId = id
                return .none

            case let .update(products):
                let sorted = products.sorted(by: { $0.price < $1.price })
                state.products = sorted
                return .none

            case .registerPublisher:
                return .publisher {
                    return purchaseManager
                        .purchasePublisher
//                        .removeDuplicates()
                        .dropFirst()
                        .map { _ in Action.handlePurchase }
                }

            case .handlePurchase:
                state.alert = AlertState(
                    title: TextState("Подписка получена!"),
                    message: TextState("Теперь вам доступны все функции приложения!"),
                    buttons: [.cancel(TextState("ОК"), action: .send(.confirm))]
                )
                
                state.hasSubscription = true

                return .none

            case .cancelTapped:
                state.alert = nil
                return .run { _ in
                    await self.dismiss()
                }

            case .alert(.presented(.confirm)):
                state.alert = nil
                return .run { _ in
                    await self.dismiss()
                }

            case .alert(.dismiss):
                return .none

            case .backTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }

}
