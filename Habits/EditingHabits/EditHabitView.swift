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
    
    @ObservedObject var habit: Habit
    
    let units = Units()
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Title")
                    TextField(
                        "Title",
                        text: $habit.habitTitle,
                        prompt: Text("Enter the habit title here")
                    )
                    .multilineTextAlignment(.trailing)
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
                }
                Picker("Unit", selection: $habit.unit) {
                    ForEach(units.units, id: \.self) {
                        Text($0)
                    }
                }
                .toolbar {
                    Button("Save") {
                        habit.objectWillChange.send()
                        try? persistenceController.save()
                        dismiss()
                    }
                }
                .onReceive(habit.objectWillChange) { _ in
                    try? persistenceController.save()
                }
            }
        }
    }
}

#Preview {
    EditHabitView(habit: Habit.example)
}
