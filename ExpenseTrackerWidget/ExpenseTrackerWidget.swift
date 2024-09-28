//
//  ExpenseTrackerWidget.swift
//  ExpenseTrackerWidget
//
//  Created by Sebastián Rubina on 2024-09-26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalExpensesOfTheMonth: data.getTotalExpensesOfTheMonth())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), totalExpensesOfTheMonth: data.getTotalExpensesOfTheMonth())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, totalExpensesOfTheMonth: data.getTotalExpensesOfTheMonth())
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalExpensesOfTheMonth: Double
}

struct ExpenseTrackerWidgetEntryView: View {
    let data = DataService()
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                HStack {
                    Text(Date(), format: .dateTime.month(.wide))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "creditcard.fill")
                        .font(.title3)
                        .foregroundColor(.pink)
                }
                .padding(.bottom, 4)
                
                Text("Expenses")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(data.getTotalExpensesOfTheMonth(), format: .currency(code: data.getCurrencyCode()))
                    .font(.system(size: data.getTotalExpensesOfTheMonth() > 9999 ? 18 : 24, weight: .bold, design: .rounded))
                    .foregroundColor(.pink)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}



struct ExpenseTrackerWidget: Widget {
    let kind: String = "ExpenseTrackerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ExpenseTrackerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ExpenseTrackerWidgetEntryView(entry: entry)
                    .background()
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("Monthly Expenses Widget")
        .description("See your expenses for the current month.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    ExpenseTrackerWidget()
} timeline: {
    SimpleEntry(date: .now, totalExpensesOfTheMonth: 125.12)
}
