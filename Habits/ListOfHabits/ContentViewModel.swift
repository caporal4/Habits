//
//  ContentViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import CoreData
import Foundation

extension ContentView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        var persistenceController: PersistenceController
        
        private let habitsController: NSFetchedResultsController<Habit>
        
        @Published var habits = [Habit]()
        @Published var newHabit = false
        
        init(persistenceController: PersistenceController) {
            self.persistenceController = persistenceController
            
            let request = Habit.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.title, ascending: true)]
            
            habitsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: persistenceController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            
            habitsController.delegate = self
            
            do {
                try habitsController.performFetch()
                habits = habitsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch habits")
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newHabits = controller.fetchedObjects as? [Habit] {
                habits = newHabits
            }
        }
        
        func showNewHabitView() {
            newHabit = true
        }
        
        func delete(_ offsets: IndexSet) {
            for offset in offsets {
                let item = habits[offset]
                persistenceController.delete(item)
                persistenceController.save()
            }
        }
    }
}
