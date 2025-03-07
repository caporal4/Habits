//
//  NewHabitViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import CoreData
import Foundation
import SwiftUI

extension NewHabitView {
    class ViewModel: ObservableObject {
        var persistenceController: PersistenceController
        
        let units = Units()
        
        @Published var title = ""
        @Published var tasksNeeded: Int?
        @Published var unit = "Count"
        @Published var reminderEnabled = false
        @Published var reminderTime = Date.now
        @Published var showingNotificationsError = false
        
        var disabledForm: Bool {
            guard let unwrapped = tasksNeeded else {
                return true
            }
            return unwrapped < 0 || title.count < 1
        }
        
        func checkSettings() {
            Task { @MainActor in
                if reminderEnabled {
                    let success = await persistenceController.addReminderNewHabit()
    
                    if success == false {
                        reminderEnabled = false
                        showingNotificationsError = true
                    }
                }
            }
        }
        
        func createAppSettingsURL() -> URL? {
            let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString)
            return settingsURL
        }
        
        func addHabit() {
            let viewContext = persistenceController.container.viewContext
            let newHabit = Habit(context: viewContext)
            newHabit.id = UUID()
            newHabit.title = title
            newHabit.tasksCompleted = 0
            newHabit.streak = 0
            newHabit.reminderEnabled = reminderEnabled
            newHabit.reminderTime = reminderTime
            if let tasksNeeded {
                newHabit.tasksNeeded = Int16(tasksNeeded)
            }
            newHabit.unit = unit
            
            updateReminder(newHabit)
            
            try? viewContext.save()
        }
        
        private func updateReminder(_ habit: Habit) {
            persistenceController.removeReminders(for: habit)
    
            Task { @MainActor in
                if habit.reminderEnabled {
                    let success = await persistenceController.addReminder(for: habit)
    
                    if success == false {
                        habit.reminderEnabled = false
                        showingNotificationsError = true
                    }
                }
            }
        }
        
        init(persistenceController: PersistenceController) {
            self.persistenceController = persistenceController
        }
    }
}
