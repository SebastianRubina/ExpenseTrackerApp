//
//  EntryListItem.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-23.
//

import SwiftUI

struct EntryListItem: View {
    @AppStorage("warningThreshold") private var warningThreshold: String = "100"
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currency?.identifier ?? "USD"
    var entry: Entry
    
    var body: some View {
        HStack {
            if let entryCategory = entry.category {
                Image(systemName: entryCategory.icon)
                    .frame(width: 40, height: 40)
                    .background {
                        Color(.sRGB, red: entryCategory.color.red, green: entryCategory.color.green, blue: entryCategory.color.blue)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading) {
                Text(entry.name)
                    .font(.headline)
                Text(TextUtils.formatDateToHumanReadable(entry.date, format: "h:mm a"))
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text("\(entry.type == .expense ? "-" : "+") \(entry.amount, format: .currency(code: selectedCurrency))")
                .foregroundStyle(entry.type == .expense ? entry.amount >= Double(warningThreshold) ?? 100 ? .red : .primary : .green)
                .font(.title3)
        }
    }
}
