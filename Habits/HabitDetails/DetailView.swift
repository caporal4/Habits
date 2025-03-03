//
//  DetailView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    
    var body: some View {
        VStack {
            if let habit = persistenceController.selectedHabit {
                HabitView(habit: habit)
            } else {
                NoHabitView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView()
        .environmentObject(PersistenceController(inMemory: true))
}
