//
//  AddEditCategory.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SymbolPicker

struct AddEditCategory: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Binding var categoryToEdit: Category?
    @State private var isEditMode: Bool = false
    
    @State private var iconPickerPresented = false
    
    @State private var categoryName: String = ""
    @State private var categoryIcon: String = "cart.fill"
    @State private var categoryColor: Color = Color(.sRGB, red: 0.25, green: 0.7, blue: 0.8)
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Enter your category name", text: $categoryName)
                }
                
                Section("Icon") {
                    Button {
                        iconPickerPresented = true
                    } label: {
                        HStack {
                            Text("Tap to change icon")
                            Spacer()
                            Image(systemName: categoryIcon)
                        }
                    }
                    .sheet(isPresented: $iconPickerPresented) {
                        SymbolPicker(symbol: $categoryIcon)
                    }
                }
                
                Section("Color") {
                    ColorPicker("Select a color", selection: $categoryColor)
                }
                
                Section("Preview") {
                    if let rgb = categoryColor.toRGB() {
                        CategoryListItem(category: Category(name: categoryName, color: ColorRGB(red: rgb.red, green: rgb.green, blue: rgb.blue), icon: categoryIcon))
                    } else {
                        Text("Invalid color selected")
                    }
                }
                
                HStack {
                    Spacer()
                    Button("\(isEditMode ? "Edit" : "Add") Category") {
                        let category = categoryToEdit ?? Category()
                        
                        category.name = categoryName
                        category.icon = categoryIcon
                        
                        if let rgb = categoryColor.toRGB() {
                            category.color = ColorRGB(red: rgb.red, green: rgb.green, blue: rgb.blue)
                        }
                        
                        if !isEditMode {
                            withAnimation {
                                context.insert(category)
                            }
                        }
                        
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .onAppear {
                    print("Category to edit: \(categoryToEdit?.name ?? "none")")
                    isEditMode = categoryToEdit != nil
                    
                    if categoryToEdit != nil {
                        categoryName = categoryToEdit?.name ?? ""
                        categoryIcon = categoryToEdit?.icon ?? "cart.fill"
                        categoryColor = categoryToEdit?.color.toColor() ?? Color(.sRGB, red: 0.25, green: 0.7, blue: 0.8)
                    }
                }
            }
            .navigationTitle("\(isEditMode ? "Edit" : "Add") Category")
        }
    }
}

#Preview {
    AddEditCategory(categoryToEdit: Binding.constant(nil))
}
