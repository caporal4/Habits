//
//  EditHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//
//  Not called anywhere yet. Still being built.

import SwiftUI

struct EditHabitView: View {
    @Environment(\.managedObjectContext) var persistenceController
    @Environment(\.dismiss) var dismiss
    
    let units = Units()
    
    @ObservedObject var habit: Habit
    
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
                            text: $habit.habitTitle,
                            prompt: Text("Enter the habit title here")
                        )
                        .multilineTextAlignment(.trailing)
                        .tint(.blue)
                    }
                    HStack {
                        Text("Amount")
                        TextField(
                            "Amount",
                            value: $habit.tasksNeeded,
                            format: .number
                        )
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .tint(.blue)
                    }
                    Picker("Unit", selection: $habit.habitUnit) {
                        ForEach(units.list, id: \.self) {
                            Text($0)
                        }
                    }
                    .tint(.secondary)
                    .toolbar {
                        Button("Save") {
                            habit.objectWillChange.send()
                            try? persistenceController.save()
                            dismiss()
                        }
                        .foregroundStyle(.blue)
                    }
                }
                .navigationTitle("Edit Habit")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .toolbarBackground(.hidden)
                .preferredColorScheme(.light)
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    EditHabitView(habit: Habit.example(controller: persistenceController))
        .environmentObject(persistenceController)
}
