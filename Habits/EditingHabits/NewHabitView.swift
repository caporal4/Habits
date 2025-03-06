//
//  NewHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: ViewModel
    
    let units = Units()
    
    init(persistenceController: PersistenceController) {
        let viewModel = ViewModel(persistenceController: persistenceController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.gradientA
                    .ignoresSafeArea()
                Form {
                    HStack {
                        Text("Title")
                        TextField(
                            "Title",
                            text: $viewModel.title,
                            prompt: Text("Enter the habit title here")
                        )
                        .multilineTextAlignment(.trailing)
                        .tint(.blue)
                    }
                    HStack {
                        Text("Amount")
                        TextField(
                            "Amount",
                            value: $viewModel.tasksNeeded,
                            format: .number
                        )
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .tint(.blue)
                    }
                    Picker("Unit", selection: $viewModel.unit) {
                        ForEach(units.list, id: \.self) {
                            Text($0)
                        }
                    }
                    .tint(.secondary)
                    .accessibilityIdentifier("Unit")
                }
                .navigationTitle("New Habit")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .toolbarBackground(.hidden)
                .preferredColorScheme(.light)
                .toolbar {
                    Button("Save") {
                        viewModel.addHabit()
                        dismiss()
                    }
                    .tint(.blue)
                    .disabled(viewModel.disabledForm)
                }
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    NewHabitView(persistenceController: .preview)
        .environmentObject(persistenceController)
}
