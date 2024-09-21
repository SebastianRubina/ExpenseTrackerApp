//
//  Expense.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import Foundation
import SwiftData

@Model
class Entry: Identifiable {
    var id: String
    var name: String
    var date: Date
    var type: EntryType
    var amount: Double
    var notes: String
    
    var category: Category?
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.date = Date()
        self.type = .expense
        self.amount = 0.0
        self.notes = ""
        self.category = Category()
    }
}

enum EntryType: String, Codable {
    case expense, income
}
