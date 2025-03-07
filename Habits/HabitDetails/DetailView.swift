//
//  DetailView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    let habit: Habit?
    
    var body: some View {
        VStack {
            if let habit = persistenceController.selectedHabit {
                HabitView(habit: habit, persistenceController: persistenceController)
            } else {
                NoHabitView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    DetailView(habit: Habit.example(controller: persistenceController))
        .environmentObject(persistenceController)
}
