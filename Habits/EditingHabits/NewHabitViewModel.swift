//
//  NewHabitViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import CoreData
import Foundation

extension NewHabitView {
    class ViewModel: ObservableObject {
        var persistenceController: PersistenceController
        
        @Published var title = ""
        @Published var tasksNeeded: Int?
        @Published var unit = "Count"
        
        let units = Units()
        
        var disabledForm: Bool {
            guard let unwrapped = tasksNeeded else {
                return true
            }
            return unwrapped < 0 || title.count < 1
        }
        
        func addHabit() {
            let viewContext = persistenceController.container.viewContext
            let newHabit = Habit(context: viewContext)
            newHabit.id = UUID()
            newHabit.title = title
            newHabit.tasksCompleted = 0
            newHabit.streak = 0
            if let tasksNeeded {
                newHabit.tasksNeeded = Int16(tasksNeeded)
            }
            newHabit.unit = unit
            
            try? viewContext.save()
        }
        
        init(persistenceController: PersistenceController) {
            self.persistenceController = persistenceController
        }
    }
}
