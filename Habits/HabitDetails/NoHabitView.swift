//
//  NoHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import SwiftUI

struct NoHabitView: View {
    @EnvironmentObject var persistenceController: PersistenceController

    var body: some View {
        Text("No Habit Selected")
            .font(.title)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    NoHabitView()
        .environmentObject(PersistenceController(inMemory: true))
}
