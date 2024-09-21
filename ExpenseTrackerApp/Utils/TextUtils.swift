//
//  TextUtils.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-20.
//

import Foundation

struct TextUtils {
    static func formatDateToHumanReadable(_ date: Date, format: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format ?? "E, d MMM yy, h:mma"
        
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}
