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
    
    @State private var showOneCategoryAlert = false
    @State private var showCategoryDeletionConfirmation = false
    
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
                                if categories.count == 1 {
                                    showOneCategoryAlert = true
                                    return
                                }
                                withAnimation {
                                    showCategoryDeletionConfirmation = true
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
                        .confirmationDialog("Deleting a category will cascade to all of its entries. Are you sure you want to delete \(category.name)\(category.entries.count > 0 ? " and all its entries? (\(category.entries.count))" : "")?", isPresented: $showCategoryDeletionConfirmation, titleVisibility: .visible) {
                            Button("Delete", role: .destructive) {
                                withAnimation {
                                    context.delete(category)
                                    try! context.save()
                                }
                            }
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
        .alert("You must have at least one category.", isPresented: $showOneCategoryAlert) {
            Button("Ok", role: .cancel) {  }
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
