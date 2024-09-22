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
    @Environment(StoreViewModel.self) private var storeViewModel
    
    @Query private var categories: [Category]
    
    var body: some View {
        if storeViewModel.purchasedSubscriptions.isEmpty {
            SubscriptionView()
        } else {
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
}

#Preview {
    @Previewable @State var storeViewModel = StoreViewModel()
    return ContentView()
        .environment(storeViewModel)
}
