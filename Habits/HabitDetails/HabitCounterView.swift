//
//  HabitCounterView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/3/25.
//

import SwiftUI

struct HabitCounterView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @ObservedObject var habit: Habit
    
    @StateObject private var viewModel: ViewModel
    
    init(habit: Habit, persistenceController: PersistenceController) {
        self.habit = habit
        let viewModel = ViewModel(persistenceController: persistenceController, habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            Button("Undo Task", systemImage: "minus", action: viewModel.undoTask)
                .labelStyle(.iconOnly)
                .padding()
                .sensoryFeedback(trigger: habit.tasksCompleted) { oldValue, newValue in
                    if oldValue > newValue {
                        .decrease
                    } else {
                        nil
                    }
                }
            VStack {
                Text("\(habit.tasksCompleted)")
                    .font(.system(size: Numbers.tasksCompletedFontSize))
                Text("/\(habit.tasksNeeded)")
                    .font(.title)
                Text(LocalizedStringKey(viewModel.convertToPlural(habit)))
                    .font(.title)
            }
            Button("Complete Task", systemImage: "plus", action: viewModel.doTask)
                .labelStyle(.iconOnly)
                .padding()
                .sensoryFeedback(trigger: habit.tasksCompleted) { oldValue, newValue in
                    if newValue > oldValue {
                        .increase
                    } else {
                        nil
                    }
                }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    HabitCounterView(habit: Habit.example(controller: persistenceController), persistenceController: .preview)
        .environmentObject(persistenceController)
}
