//
//  HabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import SwiftUI

struct HabitView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    
    @ObservedObject var habit: Habit
    
    var body: some View {
        Text(habit.habitTitle)
    }
}

#Preview {
    HabitView(habit: .example)
        .environmentObject(PersistenceController(inMemory: true))
}
