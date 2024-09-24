//
//  SubscriptionView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-21.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Environment(StoreViewModel.self) private var storeViewModel
    @State private var selectedPlan: String = "expenses.subscription.weekly"  // Default to the weekly plan
    @State private var freeTrialEnabled: Bool = true
    @State private var isPurchased = false
    
    struct Feature {
        var description: String
        var icon: String
    }
    private var features: [Feature] = [
        Feature(description: "Enter unlimited entries", icon: "list.bullet.circle"),
        Feature(description: "Detailed graphs and analytics", icon: "chart.pie"),
        Feature(description: "User-friendly interface", icon: "hand.tap"),
        Feature(description: "Customize your categories", icon: "square.and.pencil")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image(systemName: "wallet.bifold")
                    .font(Font.system(size: 150))
                    .foregroundStyle(.pink)
                
                Text("Unlimited Access")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(features, id: \.description) { feature in
                        HStack {
                            Image(systemName: feature.icon)
                                .font(.title)
                                .foregroundStyle(.pink)
                                .frame(width: 30)
                            Text(feature.description)
                                .font(.title3)
                        }
                    }
                }
                .padding(.vertical, 20)
                
                // Plan selection boxes
                VStack {
                    // Yearly Plan
                    PlanBox(planName: "Yearly Plan", price: "$39.99/yr", originalPrice: "$103.48", savePercentage: "40%", isSelected: selectedPlan == "expenses.subscription.yearly") {
                        selectedPlan = "expenses.subscription.yearly"
                        freeTrialEnabled = false  // Disable free trial for Yearly Plan
                    }
                    
                    // Weekly Plan
                    PlanBox(planName: "7-Day Trial", price: "then $1.99/wk", originalPrice: "FREE", isSelected: selectedPlan == "expenses.subscription.weekly") {
                        selectedPlan = "expenses.subscription.weekly"
                        freeTrialEnabled = true  // Enable free trial for Weekly Plan
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // Free Trial Toggle
                Toggle(isOn: $freeTrialEnabled) {
                    Text("Free Trial Enabled")
                }
                .padding(.horizontal)
                .disabled(selectedPlan != "Weekly")  // Disable the toggle if not on Weekly Plan
                
                Button {
                    // TODO: Do action here
                    print(storeViewModel.subscriptions[0].id)
                    let product = storeViewModel.subscriptions.first(where: { $0.id == selectedPlan })!
                    
                    Task {
                        await buy(product: product)
                    }
                } label: {
                    Text(selectedPlan == "expenses.subscription.weekly" ? "Try For Free" : "Get Started")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                .padding()
                
                Button("Restore") {
                    Task {
                        await restorePurchases()
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .underline()
            }
        }
    }
    
    @ViewBuilder
    func PlanBox(planName: String, price: String, originalPrice: String, savePercentage: String? = nil, isSelected: Bool, onSelect: @escaping () -> Void) -> some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading) {
                    Text(planName)
                        .font(.headline)
                    HStack {
                        if let _ = savePercentage {
                            Text(originalPrice)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .strikethrough()
                        }
                        
                        Text(price)
                    }
                }
                Spacer()
                
                if let save = savePercentage {
                    Text("SAVE \(save)")
                        .font(.subheadline)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.pink)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .pink : .secondary)
                    .font(.title)
            }
            .tint(.primary)
            .padding()
            .background(isSelected ? Color.pink.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(10)
        }
    }
    
    func buy(product: Product) async {
        do {
            if try await storeViewModel.purchase(product) != nil {
                isPurchased = true
            }
        } catch {
            print("Purchase failed.")
        }
    }
    
    func restorePurchases() async {
        do {
            try await storeViewModel.restorePurchases()
            print("Restored purchases successfully.")
        } catch {
            print("Failed to restore purchases.")
        }
    }
}

#Preview {
    @Previewable @State var storeViewModel = StoreViewModel()
    
    return SubscriptionView()
        .environment(storeViewModel)
}
