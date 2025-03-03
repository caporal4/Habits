//
//  ContentView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel: ViewModel
    
    init(persistenceController: PersistenceController) {
        let viewModel = ViewModel(persistenceController: persistenceController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.habits) { habit in
                        NavigationLink(value: habit) {
                            Text(habit.habitTitle)
                        }
                    }
                    .onDelete(perform: viewModel.delete)
                }
            }
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Habit.self) { item in
                HabitView(habit: item)
            }
            .sheet(isPresented: $viewModel.newHabit) {
                NewHabitView(persistenceController: viewModel.persistenceController)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: viewModel.showNewHabitView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
#if DEBUG
                ToolbarItem {
                    Button {
                        viewModel.persistenceController.createSampleData()
                    } label: {
                        Label("ADD SAMPLES", systemImage: "flame")
                    }
                }
                ToolbarItem {
                    Button {
                        viewModel.persistenceController.deleteAll()
                    } label: {
                        Label("DELETE SAMPLES", systemImage: "pencil")
                    }
                }
#endif
            }
        }
    }
}

#Preview {
    ContentView(persistenceController: .preview).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
