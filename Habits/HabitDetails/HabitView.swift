//
//  HabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import SwiftUI

struct FontSizes {
    static let tasksCompleted: CGFloat = 100
}

struct HabitView: View {
    @EnvironmentObject var persistenceController: PersistenceController
    @ObservedObject var habit: Habit
    
    @StateObject private var viewModel: ViewModel
    
    init(habit: Habit, persistenceController: PersistenceController) {
        self.habit = habit
        let viewModel = ViewModel(persistenceController: persistenceController, habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HabitCounterView(habit: habit, persistenceController: persistenceController)
                Spacer()
                Text("\(habit.streak) Day Streak")
                .font(.largeTitle)
            }
            
        }
        .navigationTitle(habit.habitTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
                Button("Edit", systemImage: "ellipsis") {
                    viewModel.showEditHabitView = true
                }
                Button("Delete this habit", systemImage: "trash") {
                    viewModel.showingDeleteAlert = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showEditHabitView) {
            EditHabitView(habit: habit)
        }
        .alert("Delete habit: \(habit.habitTitle)", isPresented: $viewModel.showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.delete(habit)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
    }
}

#Preview {
    HabitView(habit: .example, persistenceController: .preview)
}
