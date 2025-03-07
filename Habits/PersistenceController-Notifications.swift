//
//  PersistenceController-Notifications.swift
//  Habits
//
//  Created by Brendan Caporale on 3/7/25.
//

import Foundation
import UserNotifications

extension PersistenceController {
    func addReminder(for habit: Habit) async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                let success = try await requestNotifications()

                if success {
                    try await placeReminders(for: habit)
                } else {
                    return false
                }
            case .authorized:
                try await placeReminders(for: habit)

            default:
                return false
            }

            return true
        } catch {
            return false
        }
    }
    
    func addReminderNewHabit() async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                let success = try await requestNotifications()

                if success {
                    return true
                } else {
                    return false
                }
            case .authorized:
                return true

            default:
                return false
            }
        } catch {
            return false
        }
    }

    func removeReminders(for habit: Habit) {
        let center = UNUserNotificationCenter.current()
        let id = habit.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func requestNotifications() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound])
    }

    private func placeReminders(for habit: Habit) async throws {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = habit.habitTitle
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: habit.habitReminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let id = habit.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        return try await UNUserNotificationCenter.current().add(request)
    }
}
