//
//  CategoryList.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name) var categories: [Category]
    
    @State private var showAddEditSheet = false
    @State private var categoryToEdit: Category?
    
    var body: some View {
        VStack {
            if categories.isEmpty {
                ContentUnavailableView("No Categories", systemImage: "list.bullet.rectangle.portrait", description: Text("Add a category to get started."))
            } else {
                List(categories) { category in
                    CategoryListItem(category: category)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets()) // hides list item spacing
                        .swipeActions {
                            Button("Delete") {
                                withAnimation {
                                    context.delete(category)
                                    try! context.save()
                                }
                            }
                            .tint(.red)
                            
                            Button("Edit") {
                                print("Category passed to AddEditCategory: \(category.name)")
                                categoryToEdit = category
                                showAddEditSheet = true
                            }
                            .tint(.blue)
                        }
                }
                .listStyle(.automatic)
                .navigationTitle("Categories")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddEditSheet = true
                } label: {
                    Label("Add Category", systemImage: "plus")
                        .labelStyle(.titleOnly)
                }
            }
        }
        .sheet(isPresented: $showAddEditSheet, onDismiss: {
            categoryToEdit = nil
        }) {
            AddEditCategoryView(categoryToEdit: $categoryToEdit)
        }
    }
}

#Preview {
    CategoryListView()
}
