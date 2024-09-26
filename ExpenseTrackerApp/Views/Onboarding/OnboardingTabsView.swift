//
//  OnboardingTabs.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-23.
//

import SwiftUI

struct OnboardingTabsView: View {
    @AppStorage("onboardingComplete") private var onboardingComplete = false
    @State private var currentTab = 0
    
    var body: some View {
        TabView(selection: $currentTab){
            OnboardingEntry(title: "Manage your finances by tracking expenses and incomes!", image: "OnboardingEntries", buttonLabel: "Continue") {
                withAnimation {
                    currentTab += 1
                }
            }
            .tag(0)
            
            OnboardingEntry(title: "Easily manage and edit your expense and income categories!", image: "OnboardingCategories", buttonLabel: "Continue") {
                withAnimation {
                    currentTab += 1
                }
            }
            .tag(1)
            
            OnboardingEntry(title: "Visualize your finances with insightful charts and analytics!", image: "OnboardingInsights", buttonLabel: "Get Started!") {
                withAnimation {
                    onboardingComplete = true
                }
            }
            .tag(2)
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingTabsView()
}
