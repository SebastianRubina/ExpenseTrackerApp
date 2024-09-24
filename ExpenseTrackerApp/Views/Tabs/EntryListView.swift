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
    @Environment(\.modelContext) private var context
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
                                    EntryListItem(entry: entry)
                                        .swipeActions {
                                            Button {
                                                withAnimation {
                                                    context.delete(entry)
                                                    try! context.save()
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                                    .labelStyle(IconOnlyLabelStyle())
                                            }
                                            .tint(.red)
                                            
                                            Button {
                                                entryToEdit = entry
                                                showAddEditSheet = true
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                                    .labelStyle(IconOnlyLabelStyle())
                                            }
                                            .tint(.blue)
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
