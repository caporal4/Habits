//
//  NewHabitViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import Foundation

extension NewHabitView {
    class ViewModel: ObservableObject {
        var persistenceController: PersistenceController
        
        @Published var title = ""
        @Published var tasksNeeded: Int? = nil
        @Published var unit = "Count"
        
        let units = ["Count", "mL", "Ounce", "Gallon", "Mile", "Kilometer", "Second", "Minute", "Hour"]
        
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
            if let tasksNeeded {
                newHabit.tasksNeeded = Int16(tasksNeeded)
            }
            newHabit.unit = unit
            
            persistenceController.save()
        }
        
        init(persistenceController: PersistenceController) {
            self.persistenceController = persistenceController
        }
    }
}
