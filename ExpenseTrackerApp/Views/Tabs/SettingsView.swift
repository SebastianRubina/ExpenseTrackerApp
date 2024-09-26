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
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currency?.identifier ?? "USD"
    
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
                
                Section {
                    Button(action: {
                        sendEmail()
                    }) {
                        Text("Send Feedback or Feature Suggestions")
                            .foregroundColor(.pink)
                    }
                } header: {
                    Text("Feedback")
                } footer: {
                    Text("We’d love to hear your thoughts or suggestions! Your feedback will be taken into consideration for future updates.")
                }
                
                let availableCurrencies: [String] = {
                    let locales = Locale.availableIdentifiers.map { Locale(identifier: $0) }
                    let uniqueCurrencies = Set(locales.compactMap { $0.currency?.identifier })
                    return Array(uniqueCurrencies).sorted()
                }()
                
                Section("Currency Selection") {
                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(availableCurrencies, id: \.self) { currencyCode in
                            Text("\(currencyName(currencyCode: currencyCode)) (\(currencyCode))")
                                .tag(currencyCode)
                        }
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
                    .tint(.pink)
                }
                
                Section {
                    HStack {
                        NavigationLink("View Roadmap") {
                            RoadmapView()
                        }
                    }
                } header: {
                    Text("Roadmap")
                } footer: {
                    Text("Explore upcoming features and improvements planned for future releases!")
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
    
    func currencyName(currencyCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
        return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
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
