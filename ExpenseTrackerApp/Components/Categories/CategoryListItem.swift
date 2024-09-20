//
//  CategoryListItem.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI

struct CategoryListItem: View {
    var category: Category
    
    var body: some View {
        let backgroundColor = Color(.sRGB, red: category.color.red, green: category.color.green, blue: category.color.blue)
        // TODO: Come back to this, keep .white for now for consistency
        // let textColor: Color = backgroundColor.isLight() ? .black : .white
        HStack {
            Image(systemName: category.icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 40)
                .padding(.leading, 10)
            
            Text(category.name.capitalized)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.leading, 5)
            
            Spacer()
        }
        .padding()
        .frame(height: 60)
        .background {
            backgroundColor
        }
    }
}

#Preview {
    CategoryListItem(category: Category(name: "Groceries", color: ColorRGB(red: 0.98, green: 0.9, blue: 0.2), icon: "cart"))
}
