//
//  SettingsView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("warningThreshold") private var warningThreshold: String = "100"
    var body: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    NavigationLink("View and Edit Categories", destination: CategoryListView())
                }
                
                Section {
                    HStack {
                        Text("Current Threshold")
                        Spacer()
                        TextField("Warning Threshold", text: $warningThreshold)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                } header: {
                    Text("Warning Threshold")
                } footer: {
                    Text("Expenses that exceed this threshold will be highlighted in red in your entry list.")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
