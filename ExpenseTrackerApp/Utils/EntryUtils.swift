//
//  EntryUtils.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-20.
//

import Foundation

struct EntryUtils {
    static func calculateTotalAmountFromEntries(_ entries: [Entry]) -> Double {
        entries.reduce(0) {
            if $1.type == .expense {
                return $0 - $1.amount
            } else {
                return $0 + $1.amount
            }
        }
    }
}
