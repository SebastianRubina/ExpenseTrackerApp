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
                NavigationLink("Categories", destination: CategoryList())
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
