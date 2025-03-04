//
//  Habit-CoreDataHelpers.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import Foundation

extension Habit {
    var habitTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    var habitUnit: String {
        get { unit ?? "" }
        set { unit = newValue }
    }
    
    var habitID: UUID {
        id ?? UUID()
    }
    
    static var example: Habit {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        let habit = Habit(context: viewContext)
        habit.title = "Example Habit"
        habit.id = UUID()
        habit.tasksNeeded = 2
        habit.unit = "Count"
        return habit
    }
}
