//
//  IAPManager.swift
//  Uchiwa202408
//
//  Created by ShinnosukeYogo on 2024/08/05.
//

import StoreKit

class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    @Published var products: [SKProduct] = []
    @Published var isPurchased = false

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.gmail.goyoshin.TransparentLetters.weeklySubsc200"])
        request.delegate = self
        request.start()
    }

    func purchase(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful")
                DispatchQueue.main.async {
                    self.isPurchased = true
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Purchase failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Purchase restored")
                DispatchQueue.main.async {
                    self.isPurchased = true
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}

