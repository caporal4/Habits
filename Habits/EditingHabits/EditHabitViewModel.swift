//
//  EditHabitViewModel.swift
//  Habits
//
//  Created by Brendan Caporale on 3/7/25.
//

import Foundation
import SwiftUI

extension EditHabitView {
    class ViewModel: ObservableObject {
        var persistenceController: PersistenceController
        var habit: Habit
        
        let units = Units()
        
        @Published var showingNotificationsError = false
        
        func createAppSettingsURL() -> URL? {
            let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString)
            return settingsURL
        }
    
        func updateReminder() {
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
        
        init(persistenceController: PersistenceController, habit: Habit) {
            self.persistenceController = persistenceController
            self.habit = habit
        }
    }
}
