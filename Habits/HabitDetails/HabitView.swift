//
//  HabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import SwiftUI

struct HabitView: View {
    @StateObject private var viewModel: ViewModel
    
    @ObservedObject var habit: Habit
    
    init(habit: Habit, persistenceController: PersistenceController) {
        self.habit = habit
        let viewModel = ViewModel(persistenceController: persistenceController, habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HabitCounterView(habit: habit, persistenceController: viewModel.persistenceController)
                    Spacer()
                    Text("\(habit.streak) Day Streak")
                        .font(.largeTitle)
                }
            }
        }
        .navigationTitle(habit.habitTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
                Button("Edit Habit", systemImage: "ellipsis") {
                    viewModel.showEditHabitView = true
                }
                Button("Delete Habit", systemImage: "trash") {
                    viewModel.showingDeleteAlert = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showEditHabitView) {
            EditHabitView(habit: habit, persistenceController: viewModel.persistenceController)
        }
        .alert("Delete habit: \(habit.habitTitle)", isPresented: $viewModel.showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.delete(habit)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    HabitView(habit: Habit.example(controller: persistenceController), persistenceController: .preview)
        .environmentObject(persistenceController)
}
