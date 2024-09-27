//
//  AddEditEntryView.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-20.
//

import SwiftUI
import SwiftData
import TelemetryDeck

struct AddEditEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name) private var categories: [Category]
    
    @Binding var entryToEdit: Entry?
    @State private var isEditMode: Bool = false
    
    @State private var dateTimePickerPresented = false
    
    @State private var entryName: String = ""
    @State private var entryType: EntryType = .expense
    @State private var entryAmount: String = ""
    @State private var entryDate: Date = Date()
    @State private var entryCategory: Category? = nil
    @State private var entryNotes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Enter your entry's type") {
                    Picker("Select an entry type", selection: $entryType) {
                        Text("Expense")
                            .tag(EntryType.expense)
                        Text("Income")
                            .tag(EntryType.income)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    TextField("Enter your entry's name", text: $entryName)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                    
                    HStack {
                        Text("Amount")
                        
                        Spacer()
                        
                        Text("$")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $entryAmount)
                            .keyboardType(.decimalPad)
                            .onAppear {
                                UITextField.appearance().clearButtonMode = .whileEditing
                            }
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        Button("\(TextUtils.formatDateToHumanReadable(entryDate))") {
                            dateTimePickerPresented = true
                        }
                    }
                    
                    if categories.count > 0, let _ = entryCategory {
                        Picker("Category", selection: $entryCategory) {
                            ForEach(categories) { category in
                                HStack {
                                    Text(category.name)
                                    
                                    Spacer()
                                    
                                    Image(systemName: category.icon)
                                        .foregroundStyle(.red)
                                }
                                .tag(category)
                            }
                        }
                    }
                } header: {
                    Text("Entry Information")
                } footer: {
                    Text("You can add and edit categories in the settings page.")
                        .multilineTextAlignment(.leading)
                }
                
                Section("Add any extra notes") {
                    TextField("Notes", text: $entryNotes, axis: .vertical)
                        .lineLimit(4)
                }
                
                HStack {
                    Spacer()
                    Button("\(isEditMode ? "Edit" : "Add") Entry") {
                        let entry = entryToEdit ?? Entry()
                        
                        entry.name = entryName
                        entry.amount = Double(entryAmount) ?? 0
                        entry.date = entryDate
                        entry.type = entryType
                        entry.notes = entryNotes
                        
                        if let category = entryCategory {
                            entry.category = category
                        }
                        
                        if !isEditMode {
                            TelemetryDeck.signal(
                                "Entry.Add",
                                parameters: [
                                    "name": "\(entry.name)",
                                ]
                            )
                            
                            withAnimation {
                                context.insert(entry)
                            }
                        }
                        
                        try! context.save()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .sheet(isPresented: $dateTimePickerPresented, content: {
                    DatePicker("Date and time", selection: $entryDate)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .presentationDetents([.fraction((0.3))])
                        .presentationDragIndicator(.visible)
                })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "x.circle")
                        }
                    }
                }
                .onAppear {
                    isEditMode = entryToEdit != nil
                    
                    if let firstCategory = categories.first {
                        entryCategory = firstCategory
                    }
                    
                    if entryToEdit != nil, let firstCategory = categories.first {
                        entryName = entryToEdit?.name ?? ""
                        entryDate = entryToEdit?.date ?? Date()
                        entryAmount = String(entryToEdit?.amount ?? 0)
                        entryType = entryToEdit?.type ?? .expense
                        entryNotes = entryToEdit?.notes ?? ""
                        entryCategory = entryToEdit?.category ?? firstCategory
                    }
                }
            }
            .navigationTitle("\(isEditMode ? "Edit" : "Add") Entry")
        }
    }
}

#Preview {
    AddEditEntryView(entryToEdit: Binding.constant(nil))
}
