import ComposableArchitecture
import StoreKit

@Reducer
public struct PaywallFeature {

    @ObservableState
    public struct State: Equatable {
        let num: Int = 0
        var products: [Product] = []
    }

    public enum Action: Equatable {
        case tapped
        case onAppear
        case update(products: [Product])
        case registerPublisher
        case handlePurchase
    }


    public init() { }

    @Dependency(\.purchaseManager) var purchaseManager

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                return .run { send in
                    let products = await purchaseManager.getProducts()

                    if products.count > 0 {
                        try await purchaseManager.purchase(products[2])
                    }
                }

            case .onAppear:
                return .run { send in
                    await send(.registerPublisher)
                    await purchaseManager.observeTransactionUpdates()
                    try await purchaseManager.loadProducts()
                }

            case let .update(products):
                state.products = products
                return .none

            case .registerPublisher:
                return .publisher {
                    return purchaseManager
                        .purchasePublisher
                        .map { Action.handlePurchase }
                }

            case .handlePurchase:
                print("222222222222222")
                return .none
            }
        }
    }

}
