//
//  InsightsViewModel.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-24.
//

import Foundation
import SwiftUI

@Observable
class InsightsViewModel {
    var entries: [Entry] = []
    var categories: [Category] = []
    
    // 1. Calculate total spent this month
    static func calculateTotalSpentThisMonth(from entries: [Entry]) -> Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let totalSpent = entries.filter {
            calendar.component(.month, from: $0.date) == currentMonth &&
            calendar.component(.year, from: $0.date) == currentYear &&
            $0.type == .expense
        }.reduce(0) { $0 + $1.amount }
        
        return totalSpent
    }
    
    // 2. Calculate total spent last month
    static func calculateTotalSpentLastMonth(from entries: [Entry]) -> Double {
        let calendar = Calendar.current
        
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: Date())!
        let lastMonth = calendar.component(.month, from: lastMonthDate)
        let lastYear = calendar.component(.year, from: lastMonthDate)
        
        let totalSpent = entries.filter {
            calendar.component(.month, from: $0.date) == lastMonth &&
            calendar.component(.year, from: $0.date) == lastYear &&
            $0.type == .expense
        }.reduce(0) { $0 + $1.amount }
        
        return totalSpent
    }
    
    // 3. Generate expenses by month graph data
    func generateExpensesByMonthGraphData(for category: Category? = nil) -> [(String, Double)] {
        let calendar = Calendar.current
        var monthlyExpenses: [Int: Double] = [:]
        
        let filteredEntries = category == nil ? entries : entries.filter { $0.category == category }
        
        for entry in filteredEntries {
            if entry.type == .expense {
                let month = calendar.component(.month, from: entry.date)
                monthlyExpenses[month, default: 0.0] += entry.amount
            }
        }
        
        // Sort by month number and map back to short month symbols
        return monthlyExpenses
            .sorted { $0.key < $1.key }
            .map { (calendar.shortMonthSymbols[$0.key - 1], $0.value) }
    }
    
    // 4. Calculate total expense change per month
    func calculateTotalExpenseChangePerMonth() -> [(month: String, changeAmount: Double, changePercent: Double)] {
        let monthlyExpenses = generateExpensesByMonthGraphData()
        var changes: [(month: String, changeAmount: Double, changePercent: Double)] = []
        
        if monthlyExpenses.count > 0 {
            for i in 1..<monthlyExpenses.count {
                let current = monthlyExpenses[i]
                let previous = monthlyExpenses[i - 1]
                let changeAmount = current.1 - previous.1
                let changePercent = (changeAmount / previous.1) * 100
                changes.append((month: current.0, changeAmount: changeAmount, changePercent: changePercent))
            }
        }
        
        return changes
    }
    
    // 5. Generate expenses by category graph data
    static func generateExpensesByCategoryGraphData(from entries: [Entry]) -> [(String, Double)] {
        var categoryExpenses: [String: Double] = [:]
        
        for entry in entries {
            if entry.type == .expense, let category = entry.category {
                categoryExpenses[category.name, default: 0.0] += entry.amount
            }
        }
        
        return categoryExpenses.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
    }
    
    // 6. Generate income vs expenses graph data
    func generateIncomeVsExpensesGraphData() -> [(String, Double, Double)] {
        let calendar = Calendar.current
        var monthlyIncome: [Int: Double] = [:]
        var monthlyExpenses: [Int: Double] = [:]
        
        for entry in entries {
            let monthIndex = calendar.component(.month, from: entry.date)
            
            if entry.type == .expense {
                monthlyExpenses[monthIndex, default: 0.0] += entry.amount
            } else {
                monthlyIncome[monthIndex, default: 0.0] += entry.amount
            }
        }
        
        let months = Set(monthlyIncome.keys).union(monthlyExpenses.keys)
        
        // Sort by the actual month index, then convert to month name
        return months.sorted().map { monthIndex in
            let monthName = calendar.shortMonthSymbols[monthIndex - 1] // Convert back to month name
            let income = monthlyIncome[monthIndex] ?? 0.0
            let expense = monthlyExpenses[monthIndex] ?? 0.0
            return (monthName, income, expense)
        }
    }
    
    // 7. Generate daily spending data for past 30 days
    static func generateDailySpendingDataForPast30DaysGraphData(from entries: [Entry]) -> [(Date, Double)] {
        let calendar = Calendar.current
        var dailyExpenses: [Date: Double] = [:]
        
        // Define the date range: 30 days ago to today
        let startDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -29, to: Date())!)
        let endDate = calendar.startOfDay(for: Date())
        
        // Populate the last 30 days with 0.0 amounts, only for the past 30 days
        for dayOffset in stride(from: -29, through: 0, by: 1) {
            let date = calendar.startOfDay(for: calendar.date(byAdding: .day, value: dayOffset, to: Date())!)
            dailyExpenses[date] = 0.0
        }
        
        // Filter entries that are within the last 30 days
        let filteredEntries = entries.filter { entry in
            let entryDate = calendar.startOfDay(for: entry.date)
            return entryDate >= startDate && entryDate <= endDate
        }
        
        // Add the expenses to the corresponding days
        for entry in filteredEntries {
            if entry.type == .expense {
                let day = calendar.startOfDay(for: entry.date)
                dailyExpenses[day, default: 0.0] += entry.amount
            }
        }
        
        // Return the data as an array, sorted by date in ascending order
        return dailyExpenses.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
    }
    
    // 8. Generate average expenses by day of the week
    static func generateAverageExpensesByDayOfTheWeekGraphData(from entries: [Entry]) -> [(String, Double)] {
        let calendar = Calendar.current
        var weekdayExpenses: [String: (count: Int, total: Double)] = [:]
        
        for entry in entries {
            if entry.type == .expense {
                let weekday = calendar.weekdaySymbols[calendar.component(.weekday, from: entry.date) - 1]
                weekdayExpenses[weekday, default: (0, 0.0)].count += 1
                weekdayExpenses[weekday]?.total += entry.amount
            }
        }
        
        return weekdayExpenses.map { (weekday, data) in
            let average = data.total / Double(data.count)
            return (weekday, average)
        }.sorted { $0.0 < $1.0 }
    }
    
    // 9. Get top individual expense items
    static func getTopIndividualExpenseItems(from entries: [Entry], limit: Int = 5) -> [(String, Date, Double)] {
        let sortedEntries = entries.filter { $0.type == .expense }.sorted { $0.amount > $1.amount }
        
        return sortedEntries.prefix(limit).map { (entry) in
            (entry.name, entry.date, entry.amount)
        }
    }
}
