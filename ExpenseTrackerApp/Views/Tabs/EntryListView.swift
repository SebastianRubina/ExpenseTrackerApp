//
//  ExpenseListView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData
import StoreKit

struct EntryListView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("warningThreshold") private var warningThreshold = "100"
    @Query private var entries: [Entry]
    
    @State private var showAddEditSheet = false
    @State private var entryToEdit: Entry?
    
    // Helper function to group and sort entries
    private func groupEntriesByDay() -> [(key: Date, value: [Entry])] {
        let calendar = Calendar.current
        
        // Break down the grouping and sorting into smaller steps
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.date) // Group by the start of the day
        }
        
        // Sort the grouped entries by date
        let sorted = grouped.sorted { $0.key > $1.key }
        
        return sorted
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if entries.isEmpty {
                    ContentUnavailableView("No Entries", systemImage: "wallet.bifold", description: Text("Add an entry to get started."))
                } else {
                    EntryListOverview()
                    
                    List {
                        // Use the helper function to break down the logic
                        ForEach(groupEntriesByDay(), id: \.key) { (date, entriesForDay) in
                            Section(header: Text(TextUtils.formatDateToHumanReadable(date, format: "MMM d, yyyy"))) {
                                ForEach(entriesForDay.sorted(by: { $0.date > $1.date })) { entry in
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
                                        
                                        Text("\(entry.type == .expense ? "-" : "+") \(entry.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                            .foregroundStyle(entry.type == .expense ? entry.amount >= Double(warningThreshold) ?? 100 ? .red : .white : .green)
                                            .font(.title2)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddEditSheet = true
                    } label: {
                        Label("Add Entry", systemImage: "plus")
                            .labelStyle(.titleOnly)
                    }
                }
            }
            .sheet(isPresented: $showAddEditSheet) {
                if entries.count % 20 == 0 {
                    requestReview()
                }
            } content: {
                AddEditEntryView(entryToEdit: $entryToEdit)
            }
            
        }
    }
}

#Preview {
    EntryListView()
}
