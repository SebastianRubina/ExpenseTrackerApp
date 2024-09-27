//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import Inject
import SwiftUI
import SwiftData
import TelemetryDeck

@main
struct ExpenseTrackerAppApp: App {
    
    init() {
        let config = TelemetryDeck.Config(appID:  Bundle.main.infoDictionary?["TELEMETRY_DECK_APP_ID"] as? String ?? "")
        TelemetryDeck.initialize(config: config)
    }
    
    
    @ObserveInjection var inject
    @State var storeViewModel: StoreViewModel = StoreViewModel()
    @State var insightsViewModel: InsightsViewModel = InsightsViewModel()
    
    let container: ModelContainer = {
        let schema = Schema([Category.self, Entry.self])
        let container = try! ModelContainer(for: schema)
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .environment(storeViewModel)
                .environment(insightsViewModel)
                .enableInjection()
        }
    }
}
