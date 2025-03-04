//
//  HabitCounterView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/3/25.
//

import SwiftUI

struct HabitCounterView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @ObservedObject var habit: Habit
    
    @StateObject private var viewModel: ViewModel
    
    init(habit: Habit, persistenceController: PersistenceController) {
        self.habit = habit
        let viewModel = ViewModel(persistenceController: persistenceController, habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            Button("", systemImage: "minus") {
                viewModel.undoTask()
            }
            .foregroundStyle(.black)
            .padding()
            VStack {
                Text("\(habit.tasksCompleted)")
                    .font(.system(size: FontSizes.tasksCompleted))
                Text("/\(habit.tasksNeeded)")
                    .font(.title)
                Text(habit.habitUnit)
                    .font(.title)
            }
            Button("", systemImage: "plus") {
                viewModel.doTask()
            }
            .foregroundStyle(.black)
            .padding()
        }
    }
}

#Preview {
    HabitCounterView(habit: .example, persistenceController: .preview)
}
