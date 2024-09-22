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
    
    @Environment(StoreViewModel.self) private var storeViewModel
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
                
                Section("Feedback") {
                    Button(action: {
                        sendEmail()
                    }) {
                        Text("Send Feedback or Feature Suggestions")
                            .foregroundColor(.blue)
                    }
                }
                
                Section("Restore Purchases") {
                    Button {
                        Task {
                            await restorePurchases()
                        }
                    } label: {
                        Text("Restore purchases")
                    }
                    .tint(.blue)
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    func restorePurchases() async {
        do {
            try await storeViewModel.restorePurchases()
            print("Restored purchases successfully.")
        } catch {
            print("Failed to restore purchases.")
        }
    }
    
    private func sendEmail() {
        let email = "sebastianrubinas@gmail.com"
        let subject = "FEEDBACK - Expense Tracker App"
        let body = ""
        let formattedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let formattedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let emailUrl = URL(string: "mailto:\(email)?subject=\(formattedSubject)&body=\(formattedBody)")!
        
        if UIApplication.shared.canOpenURL(emailUrl) {
            UIApplication.shared.open(emailUrl)
        } else {
            print("Email app cannot be opened.")
        }
    }
}

#Preview {
    @Previewable @State var storeViewModel = StoreViewModel()
    
    SettingsView()
        .environment(storeViewModel)
}
