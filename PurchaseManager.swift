//
//  PurchaseManager.swift
//  Uchiwa202408
//
//  Created by ShinnosukeYogo on 2024/08/05.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {


    private let productId = ["com.gmail.goyoshin.TransparentLetters.weeklySubsc200"]

    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>()

    private let entitlementManager: EntitlementManager
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil

    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        self.updates = observeTransactionUpdates()
    }

    deinit {
        self.updates?.cancel()
    }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productId)
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Successful purchase
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified(_, _)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }

        self.entitlementManager.hasPro = !self.purchasedProductIDs.isEmpty
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
          for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}
