//
//  DataService.swift
//  ExpenseTrackerWidgetExtension
//
//  Created by Sebastián Rubina on 2024-09-26.
//

import Foundation
import SwiftUI

struct DataService {
    @AppStorage(
        "totalExpensesOfTheMonth",
        store: UserDefaults(
            suiteName: "group.com.sebastianrubina.ExpenseTrackerApp"
        )
    ) private var totalExpensesOfTheMonth: Double = 0.0
    
    @AppStorage(
        "selectedCurrency",
        store: UserDefaults(
            suiteName: "group.com.sebastianrubina.ExpenseTrackerApp"
        )
    ) private var selectedCurrency: String = Locale.current.currency?.identifier ?? "USD"
    
    func getTotalExpensesOfTheMonth() -> Double {
        return totalExpensesOfTheMonth
    }
    
    func getCurrencyCode() -> String {
        return selectedCurrency
    }
    
    
}
