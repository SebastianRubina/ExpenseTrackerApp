//
//  EntryListOverview.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-20.
//

import SwiftUI
import SwiftData

struct EntryListOverview: View {
    @Query private var entries: [Entry]
    @AppStorage(
        "selectedCurrency",
        store: UserDefaults(
            suiteName: "group.com.sebastianrubina.ExpenseTrackerApp"
        )
    ) private var selectedCurrency: String = Locale.current.currency?.identifier ?? "USD"
    @AppStorage("totalExpensesOfTheMonth", store: UserDefaults(suiteName: "group.com.sebastianrubina.ExpenseTrackerApp")) private var totalExpensesOfTheMonth: Double = 0.0
    
    @State private var selectedTimeFilter: TimeFilter = .thisMonth
    
    var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }
    
    var filteredEntries: [Entry] {
        switch selectedTimeFilter {
        case .allTime:
            return entries
        case .thisMonth:
            let calendar = Calendar.current
            let now = Date()
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            return entries.filter { $0.date >= startOfMonth && $0.date <= now }
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Expense Overview")
                .font(.title)
                .bold()
                .padding(.top)
            
            Picker("Time Filter", selection: $selectedTimeFilter) {
                ForEach(TimeFilter.allCases) {
                    Text($0 == .thisMonth ? currentMonthName : $0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text((EntryUtils.calculateTotalAmountFromEntries(filteredEntries)), format: .currency(code: selectedCurrency))
                .font(.largeTitle)
                .bold()
            
            HStack {
                let incomeEntries = filteredEntries.filter { $0.type == .income }
                Text("+\(EntryUtils.calculateTotalAmountFromEntries(incomeEntries), format: .currency(code: selectedCurrency))")
                    .foregroundColor(.green) // Optional, to differentiate income visually
                
                Divider()
                
                let expenseEntries = filteredEntries.filter { $0.type == .expense }
                Text("\(EntryUtils.calculateTotalAmountFromEntries(expenseEntries), format: .currency(code: selectedCurrency))")
                    .foregroundColor(.red) // Optional, to differentiate expenses visually
            }
            .frame(height: 20)
        }
        .onAppear {
            totalExpensesOfTheMonth = calculateTotalExpensesOfTheMonth()
        }
    }
    
    func calculateTotalExpensesOfTheMonth() -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        
        // Filter entries for the current month and sum up the expenses
        let monthlyExpenseEntries = entries.filter { $0.date >= startOfMonth && $0.date <= now && $0.type == .expense }
        return monthlyExpenseEntries.reduce(0) { $0 + $1.amount }
    }
    
    enum TimeFilter: String, CaseIterable, Identifiable {
        case allTime = "All Time"
        case thisMonth = "This Month"
        
        var id: String { self.rawValue }
    }
}

#Preview {
    EntryListOverview()
}
