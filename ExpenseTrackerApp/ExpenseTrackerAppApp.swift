//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerAppApp: App {
    let container: ModelContainer = {
        let schema = Schema([Category.self, Expense.self])
        let container = try! ModelContainer(for: schema)
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
