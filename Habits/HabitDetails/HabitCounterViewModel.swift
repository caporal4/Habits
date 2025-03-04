//
//  HabitCounterViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/3/25.
//

import Foundation

extension HabitCounterView {
    class ViewModel: ObservableObject {
        var persistenceController: PersistenceController
        var habit: Habit
        
        func doTask() {
            guard habit.tasksCompleted < habit.tasksNeeded else { return }
            habit.tasksCompleted += 1
            if habit.tasksCompleted == habit.tasksNeeded {
                habit.streak += 1
            }
            persistenceController.save()
        }
        
        func undoTask() {
            guard habit.tasksCompleted > 0 else { return }
            if habit.tasksCompleted == habit.tasksNeeded {
                habit.streak -= 1
            }
            habit.tasksCompleted -= 1
            persistenceController.save()
        }
        
        init(persistenceController: PersistenceController, habit: Habit) {
            self.persistenceController = persistenceController
            self.habit = habit
        }
    }
}
