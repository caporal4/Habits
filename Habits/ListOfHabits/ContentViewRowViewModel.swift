//
//  ContentViewRowViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/6/25.
//

import Foundation

extension ContentViewRow {
    class ViewModel: ObservableObject {
        var habit: Habit
        
        let units = Units()
        
        func convertToPlural(habit: Habit) -> String {
            if habit.tasksNeeded == 1 {
                return habit.habitUnit
            } else {
                if let index = units.list.firstIndex(of: habit.habitUnit) {
                    if habit.tasksNeeded == 1 {
                        return units.list[index]
                    } else {
                        return units.pluralList[index]
                    }
                }
                return habit.habitUnit
            }
        }
        
        init(habit: Habit) {
            self.habit = habit
        }
    }
}
