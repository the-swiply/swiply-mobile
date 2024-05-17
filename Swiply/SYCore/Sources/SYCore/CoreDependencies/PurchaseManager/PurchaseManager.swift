import Foundation
import ComposableArchitecture
import Networking
import StoreKit
import Combine

// MARK: - PurchaseManager

public protocol PurchaseManager {

    func loadProducts() async throws
    func purchase(_ product: Product) async throws
    func updatePurchasedProducts() async
    func observeTransactionUpdates() async
    func getProducts() async -> [Product]
    
    var purchasePublisher: AnyPublisher<Void, Never> { get }

}

// MARK: - DependencyKey

enum PurchaseManagerKey: DependencyKey {

    public static var liveValue: any PurchaseManager = LivePurchaseManager()

}

// MARK: - DependencyValues

public extension DependencyValues {

  var purchaseManager: PurchaseManager {
    get { self[PurchaseManagerKey.self] }
    set { self[PurchaseManagerKey.self] = newValue }
  }

}

// MARK: - AppStateManager

public actor LivePurchaseManager: PurchaseManager {

    public let purchasePublisher: AnyPublisher<Void, Never>

    var purchaseSubject: CurrentValueSubject<Void, Never>

    private let productIds = ["Swiply.3monthly", "Swiply.monthly", "Swiply.yearly"]

    public private(set) var products: [Product] = []
    private(set) var purchasedProductIDs = Set<String>()

    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil

    init() {
        purchaseSubject = CurrentValueSubject<Void, Never>(())
        purchasePublisher = purchaseSubject.eraseToAnyPublisher()
    }

    deinit {
        self.updates?.cancel()
    }

    public func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    public func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            purchaseSubject.send()
            await transaction.finish()
            await self.updatePurchasedProducts()

        case let .success(.unverified(_, error)):
            break

        case .pending:
            break

        case .userCancelled:
            break

        @unknown default:
            break
        }
    }

    public func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                self.purchaseSubject.send()
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }

    public func observeTransactionUpdates() async {
        updates = Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }

    public func getProducts() async -> [Product] {
        products
    }

}
