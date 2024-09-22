//
//  StoreViewModel.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-21.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

@Observable
class StoreViewModel {
    var subscriptions: [Product] = []
    var purchasedSubscriptions: [Product] = []
    var subscriptionGroupStatus: RenewalState?
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    private let productIds: [String] = ["expenses.subscription.weekly", "expenses.subscription.yearly"]
    
    init() {
        
        updateListenerTask = listenForTransaction()
        
        Task {
            await requestProducts()
            
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransaction() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification.")
                }
            }
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            // request from the appstore using hardcoded product ids
            subscriptions = try await Product.products(for: productIds)
            print("Products: \(subscriptions)")
        } catch {
            print("Failed product request: \(error)")
        }
    }
    
    func restorePurchases() async throws {
        try await AppStore.sync()
        
        // Iterate over each subscription and check if there are valid transactions
        for product in subscriptions {
            if let result = await Transaction.latest(for: product.id) {
                // Verify the transaction
                switch result {
                case .verified(let transaction):
                    if transaction.revocationReason == nil {
                        purchasedSubscriptions.append(product) // Add the product to the purchased list
                    }
                case .unverified(_, _):
                    print("Transaction for product \(product.id) is unverified.")
                }
            }
        }
    }
    
    // purchase the product
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            // check whether the transaction is verified
            let transaction = try checkVerified(verification)
            
            // the transaction is verified
            await updateCustomerProductStatus()
            
            // always finish the transaction
            await transaction.finish()
            
            return transaction
            
        case.userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // check whether the JWS passes StoreKit verification
        switch result {
        case .unverified:
            // StoreKit parses JWS, but it fails verification
            throw StoreError.failedVerification
        case .verified(let safe):
            // the result is verified, return the unwrapped value
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                // check whether transaction is verified. If it isn't, catch 'failedVerification' error
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
                // always finish transaction
                await transaction.finish()
            } catch {
                print("Failed to update products.")
            }
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}
