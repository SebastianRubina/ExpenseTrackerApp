//
//  Expense.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import Foundation
import SwiftData

@Model
class Expense: Identifiable {
    var id: String
    var name: String
    var date: Date
    var amount: Double
    var notes: String?
    var category: Category
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.date = Date()
        self.amount = 0.0
        self.notes = ""
        self.category = Category()
    }
}


