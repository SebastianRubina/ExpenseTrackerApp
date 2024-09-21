//
//  ContentView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("firstOpen") private var firstOpen: Bool = true
    @Environment(\.modelContext) private var context
    
    @Query private var categories: [Category]
    
    var body: some View {
        TabView {
            Tab("Entries", systemImage: "wallet.bifold") {
                EntryListView()
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
        .tint(.pink)
        .onAppear {
            if firstOpen {
                CategoryUtils.initializeDefaultCategories(context: context)
                firstOpen = false
            }
        }
    }
}

#Preview {
    ContentView()
}
