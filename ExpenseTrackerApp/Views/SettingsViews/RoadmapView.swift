//
//  RoadmapView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-23.
//

import SwiftUI

struct RoadmapView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Here is what to expect in the near future")) {
                    ForEach(upcomingFeatures.sorted { $0.isCompleted && !$1.isCompleted }) { feature in
                        HStack {
                            Image(systemName: feature.isCompleted ? "checkmark.circle" : "circle")
                                .foregroundStyle(feature.isCompleted ? .pink : .primary)
                            Text(feature.title)
                                .font(.body)
                        }
                    }
                }
            }
            .navigationTitle("Roadmap")
        }
    }
    
    // Feature model
    struct Feature: Identifiable {
        let id = UUID() // Unique identifier
        let title: String
        var isCompleted: Bool
    }
    
    // List of upcoming features
    private let upcomingFeatures: [Feature] = [
        Feature(title: "Customize currency settings", isCompleted: true),
        Feature(title: "Add widgets for quick access", isCompleted: false),
        Feature(title: "Track pending debts from others", isCompleted: false),
        Feature(title: "Share debts with borrowers", isCompleted: false),
        Feature(title: "Gain deeper financial insights", isCompleted: false),
        Feature(title: "Allow for data to sync with cloud", isCompleted: false)
    ]
}

#Preview {
    RoadmapView()
}
