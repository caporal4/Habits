//
//  HabitsApp.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import SwiftUI

@main
struct HabitsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
