//
//  ExpenseListView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData

struct EntryListView: View {
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
                                ForEach(entriesForDay) { entry in
                                    HStack {
                                        Image(systemName: entry.category.icon)
                                            .frame(width: 40, height: 40)
                                            .background {
                                                Color(.sRGB, red: entry.category.color.red, green: entry.category.color.green, blue: entry.category.color.blue)
                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        VStack(alignment: .leading) {
                                            Text(entry.name)
                                                .font(.headline)
                                            Text(TextUtils.formatDateToHumanReadable(entry.date, format: "h:mm a"))
                                                .foregroundStyle(.secondary)
                                                .font(.subheadline)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(entry.type == .expense ? "-" : "+") \(entry.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                                            .foregroundStyle(entry.type == .expense ? .white : .green)
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
                AddEditEntryView(entryToEdit: $entryToEdit)
            }
        }
    }
}

#Preview {
    EntryListView()
}
