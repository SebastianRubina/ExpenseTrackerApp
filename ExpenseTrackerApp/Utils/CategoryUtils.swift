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
                Category(name: "Groceries", color: ColorRGB(red: 48/255, green: 176/255, blue: 199/255), icon: "cart.fill"),
                Category(name: "Dining Out", color: ColorRGB(red: 0/255, green: 199/255, blue: 190/255), icon: "fork.knife"),
                Category(name: "Transportation", color: ColorRGB(red: 50/255, green: 173/255, blue: 230/255), icon: "car.fill"),
                Category(name: "Entertainment", color: ColorRGB(red: 88/255, green: 86/255, blue: 214/255), icon: "film.fill"),
                Category(name: "Utilities", color: ColorRGB(red: 255/255, green: 149/255, blue: 0/255), icon: "bolt.fill"),
                Category(name: "Health & Fitness", color: ColorRGB(red: 255/255, green: 45/255, blue: 85/255), icon: "heart.fill")
            ]
            
            for category in defaultCategories {
                context.insert(category)
            }
            
            // Save the context
            try? context.save()
        }
    }
}
