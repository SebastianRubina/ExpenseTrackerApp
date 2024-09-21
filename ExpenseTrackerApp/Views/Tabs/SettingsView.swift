//
//  SettingsView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData

struct SettingsView: View {    
    var body: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    NavigationLink("View and Edit Categories", destination: CategoryListView())
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
