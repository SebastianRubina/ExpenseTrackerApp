//
//  InsightsView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-24.
//

import SwiftUI
import SwiftData
import Charts
import TelemetryDeck

struct InsightsView: View {
    @Environment(InsightsViewModel.self) private var insightsViewModel
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currency?.identifier ?? "USD"
    
    @Query(sort: \Entry.date) private var entries: [Entry]
    @Query private var categories: [Category]
    @State private var selectedCategory: Category?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Insights")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                summaryCards
                
                expensesByMonthChart
                expensesByCategoryChart
                incomeVsExpensesChart
                dailySpendingChart
                averageExpensesByDayOfWeekChart
                topExpensesList
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            insightsViewModel.entries = entries
            insightsViewModel.categories = categories
            TelemetryDeck.signal(
                "Insights.Visited"
            )
        }
    }
    
    private var summaryCards: some View {
        VStack(alignment: .leading) {
            Text("Expense Comparison")
                .font(.headline)
            
            HStack(spacing: 16) {
                let valueSpentThisMonth = InsightsViewModel.calculateTotalSpentThisMonth(from: insightsViewModel.entries)
                let valueSpentLastMonth = InsightsViewModel.calculateTotalSpentLastMonth(from: insightsViewModel.entries)
                let percentageChangeBetweenThisAndLastMonth = 100 - (valueSpentThisMonth * 100 / valueSpentLastMonth)
                
                summaryCard(title: "Last Month's Expenses", value: valueSpentLastMonth, color: .green)
                
                summaryCard(title: "This Month's Expenses", value: valueSpentThisMonth, percentChange: percentageChangeBetweenThisAndLastMonth, color: .blue)
            }
        }
    }
    
    private func summaryCard(title: String, value: Double, percentChange: Double? = nil, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text(value, format: .currency(code: selectedCurrency))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                if let percentChange = percentChange {
                    Text(percentChange > 0 ? "-\(percentChange, specifier: "%.1f")%" : "+\(percentChange * -1, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundStyle(percentChange > 0 ? Color.green.gradient : Color.red.gradient)
                }
                
                Spacer()
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemGroupedBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private var expensesByMonthChart: some View {
        ChartView(title: "Expenses by Month", description: "Shows total expenses for each month over the past year.") {
            Chart {
                ForEach(insightsViewModel.generateExpensesByMonthGraphData(for: selectedCategory), id: \.0) { month, amount in
                    BarMark(
                        x: .value("Month", month),
                        y: .value("Amount", amount)
                    )
                    .foregroundStyle(Color.pink.gradient)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
    
    private var expensesByCategoryChart: some View {
        ChartView(title: "Expenses by Category", description: "Displays the distribution of expenses across different categories.") {
            Chart {
                ForEach(InsightsViewModel.generateExpensesByCategoryGraphData(from: insightsViewModel.entries), id: \.0) { category, amount in
                    
                    SectorMark(
                        angle: .value("Amount", amount),
                        innerRadius: .ratio(0.6),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Category", category))
                }
            }
        }
    }
    
    private var incomeVsExpensesChart: some View {
        ChartView(title: "Income vs Expenses", description: "Compares monthly income (green) against expenses (red) over time.") {
            Chart {
                ForEach(insightsViewModel.generateIncomeVsExpensesGraphData(), id: \.0) { month, income, expense in
                    BarMark(
                        x: .value("Month", month),
                        y: .value("Amount", income)
                    )
                    .foregroundStyle(Color.green.gradient)
                    .position(by: .value("Amount", income)) // This will ensure bars are placed side by side
                    
                    BarMark(
                        x: .value("Month", month),
                        y: .value("Amount", expense)
                    )
                    .foregroundStyle(Color.red.gradient)
                    .position(by: .value("Amount", expense)) // Use the same approach for expense bars
                }
            }
            .chartXAxis {
                AxisMarks()
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
    
    private var dailySpendingChart: some View {
        ChartView(title: "Daily Spending (Last 30 Days)", description: "Shows your daily spending pattern over the past month.") {
            Chart {
                ForEach(InsightsViewModel.generateDailySpendingDataForPast30DaysGraphData(from: insightsViewModel.entries), id: \.0) { date, amount in
                    BarMark(
                        x: .value("Date", date),
                        y: .value("Amount", amount == 0 ? 1 : amount)
                    )
                    .foregroundStyle(Color.pink.gradient)
                }
            }
            .chartXAxis {
                AxisMarks(values: generateXAxisMarks()) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month().day(), centered: false) // Format: "Jul 4"
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
    
    private func generateXAxisMarks() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -29, to: Date())!) // 30 days ago
        
        // Define the interval between each label
        let interval = 30 / 6 // 6 intervals for 7 labels
        
        // Generate 7 labels evenly spaced across the last 30 days
        var labels: [Date] = []
        for i in 0..<7 {
            let labelDate = calendar.date(byAdding: .day, value: i * interval, to: startDate)!
            labels.append(labelDate)
        }
        
        return labels
    }
    
    private var averageExpensesByDayOfWeekChart: some View {
        ChartView(title: "Average Expenses by Day of Week", description: "Displays the average spending for each day of the week.") {
            Chart {
                ForEach(Calendar.current.weekdaySymbols, id: \.self) { day in
                    let data = InsightsViewModel.generateAverageExpensesByDayOfTheWeekGraphData(from: insightsViewModel.entries)
                    let amount = data.first(where: { $0.0 == day })?.1 ?? 0
                    
                    BarMark(
                        x: .value("Day", day),
                        y: .value("Average", amount)
                    )
                    .foregroundStyle(Color.pink.gradient)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
    
    private var topExpensesList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Expenses")
                .font(.headline)
            
            ForEach(InsightsViewModel.getTopIndividualExpenseItems(from: insightsViewModel.entries), id: \.1) { name, date, amount in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(amount, format: .currency(code: selectedCurrency))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemGroupedBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct ChartView<Content: View>: View {
    let title: String
    let description: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            content()
                .frame(height: 200)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemGroupedBackground)))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    @Previewable @State var insightsViewModel = InsightsViewModel()
    
    return InsightsView()
        .environment(insightsViewModel)
}
