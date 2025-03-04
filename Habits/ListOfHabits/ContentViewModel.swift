//
//  ContentViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import CoreData
import Foundation
import SwiftUI

extension ContentView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        var persistenceController: PersistenceController
        var loginTracker = LoginTracker()
        
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
        
        func reloadData() {
            let request = Habit.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.title, ascending: true)]
            
            let newController: NSFetchedResultsController<Habit>
            newController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: persistenceController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            do {
                try newController.performFetch()
                habits = newController.fetchedObjects ?? []
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
        func launchApp() {
            let loginTime = Date.now
            
            loginTracker.loginList.insert(loginTime, at: 0)
            
            let dateOne = Calendar.current.dateComponents([.day, .year, .month], from: loginTracker.loginList[0])
            
            if loginTracker.loginList.count > 1 {
                let dateTwo = Calendar.current.dateComponents([.day, .year, .month], from: loginTracker.loginList[1])
                if dateOne != dateTwo {
                    for habit in habits {
                        if habit.tasksCompleted < habit.tasksNeeded {
                            habit.streak = 0
                        }
                        habit.tasksCompleted = 0
                    }
                }
            }
        }
    }
}
