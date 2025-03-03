//
//  NewHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import SwiftUI

struct NewHabitView: View {
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(persistenceController: PersistenceController) {
        let viewModel = ViewModel(persistenceController: persistenceController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField(
                    "Title",
                    text: $viewModel.title,
                    prompt: Text("Enter the habit title here")
                )
                HStack {
                    Text("Amount?")
                    TextField("Amount", value: $viewModel.tasksNeeded, format: .number)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                Picker("Unit", selection: $viewModel.unit) {
                    ForEach(viewModel.units, id: \.self) {
                        Text($0)
                    }
                }
            }
            .toolbar {
                Button("Save") {
                    viewModel.addHabit()
                    dismiss()
                }
                .disabled(viewModel.disabledForm)
            }
        }
    }
}

#Preview {
    NewHabitView(persistenceController: .preview).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
