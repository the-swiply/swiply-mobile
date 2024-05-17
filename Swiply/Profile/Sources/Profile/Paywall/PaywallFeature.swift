import ComposableArchitecture
import StoreKit

@Reducer
public struct PaywallFeature {

    let productIds = ["Swiply.monthly", "Swiply.yearly", "Swiply.InAppTest"]

    @ObservableState
    public struct State: Equatable {
        let num: Int = 0
        var products: [Product] = []
    }

    public enum Action: Equatable {
        case tapped
        case onAppear
        case update(products: [Product])
    }


    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tapped:
                return .run { [state] send in
                    let result = try await state.products[0].purchase()
                }

            case .onAppear:
                return .run { send in
                    let products = try await Product.products(for: productIds)
                    print(products)
                    await send(.update(products: products))
                }

            case let .update(products):
                state.products = products
                return .none
            }
        }
    }

}
