//
//  EditHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//
//Not called anywhere yet. Still being built.

import SwiftUI

struct EditHabitView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var habit: Habit
    
    let units = ["Count", "mL", "Ounce", "Gallon", "Mile", "Kilometer", "Second", "Minute", "Hour"]
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    TextField(
                        "Title",
                        text: $habit.habitTitle,
                        prompt: Text("Enter the habit title here")
                    )
                    Picker("Unit", selection: $habit.habitUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .toolbar {
                    Button("Save") {
                        persistenceController.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EditHabitView(habit: Habit.example)
        .environmentObject(PersistenceController(inMemory: true))
}
