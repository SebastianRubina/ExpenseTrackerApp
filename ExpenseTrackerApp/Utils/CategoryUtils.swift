//
//  CategoryUtils.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import Foundation
import SwiftData
import SwiftUI

struct CategoryUtils {
    static func initializeDefaultCategories(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Category>()
        let existingCategories = try? context.fetch(fetchDescriptor)
        
        if existingCategories?.isEmpty ?? true {
            // No categories exist, so add default categories
            let defaultCategories = [
                Category(name: "Groceries", color: ColorRGB(red: 102/255, green: 192/255, blue: 204/255), icon: "cart.fill"), // Stronger teal
                Category(name: "Dining Out", color: ColorRGB(red: 85/255, green: 205/255, blue: 198/255), icon: "fork.knife"), // Bolder aqua
                Category(name: "Transportation", color: ColorRGB(red: 90/255, green: 175/255, blue: 220/255), icon: "car.fill"), // Deeper sky blue
                Category(name: "Entertainment", color: ColorRGB(red: 130/255, green: 120/255, blue: 220/255), icon: "film.fill"), // Deeper purple
                Category(name: "Utilities", color: ColorRGB(red: 255/255, green: 165/255, blue: 79/255), icon: "bolt.fill"), // Stronger orange
                Category(name: "Health & Fitness", color: ColorRGB(red: 255/255, green: 92/255, blue: 118/255), icon: "heart.fill"), // Punchier pink
                
                // Stronger contrast for additional categories
                Category(name: "Salary", color: ColorRGB(red: 110/255, green: 180/255, blue: 145/255), icon: "dollarsign.circle.fill"), // Stronger pastel green
                Category(name: "Other Income", color: ColorRGB(red: 150/255, green: 210/255, blue: 85/255), icon: "banknote.fill"), // Bolder pastel greenish yellow
                //                Category(name: "Settled Debt", color: ColorRGB(red: 230/255, green: 190/255, blue: 85/255), icon: "person.crop.circle.badge.exclamationmark.fill") // Stronger yellow
                
                Category(name: "Rent", color: ColorRGB(red: 240/255, green: 100/255, blue: 75/255), icon: "house.fill"), // Warm reddish-orange
                Category(name: "Debt Repayment", color: ColorRGB(red: 230/255, green: 130/255, blue: 60/255), icon: "creditcard.fill") // Muted orange-red
            ] 
            
            for category in defaultCategories {
                context.insert(category)
            }
            
            // Save the context
            try? context.save()
        }
    }
}
