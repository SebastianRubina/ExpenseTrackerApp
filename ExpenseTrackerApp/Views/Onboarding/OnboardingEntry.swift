//
//  OnboardingEntry.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-23.
//

import SwiftUI

struct OnboardingEntry: View {
    var title: String
    var image: String
    var buttonLabel: String
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color.pink
                .ignoresSafeArea()
            
            VStack {
                
                
                
                Text(title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                Spacer()
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 10)
                
                Spacer()
                
                Button {
                    onContinue()
                } label: {
                    Text(buttonLabel)
                        .frame(width: 270, height: 30)
                        .bold()
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .tint(.white)
                .foregroundStyle(.pink)
                .padding()
                .padding(.bottom, 25)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    OnboardingEntry(title: "Manage your finances by tracking expenses and incomes!", image: "OnboardingEntries", buttonLabel: "Continue") {
        //
    }
}
