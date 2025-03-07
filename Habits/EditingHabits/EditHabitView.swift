//
//  EditHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @StateObject private var viewModel: ViewModel
    
    @ObservedObject var habit: Habit
    
    init(habit: Habit, persistenceController: PersistenceController) {
        self.habit = habit
        let viewModel = ViewModel(persistenceController: persistenceController, habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.gradientA
                    .ignoresSafeArea()
                Form {
                    Section("Habit Information") {
                        HStack {
                            Text("Title")
                            TextField(
                                "Title",
                                text: $viewModel.habit.habitTitle,
                                prompt: Text("Enter the habit title here")
                            )
                            .multilineTextAlignment(.trailing)
                            .tint(.blue)
                        }
                        HStack {
                            Text("Amount")
                            TextField(
                                "Amount",
                                value: $viewModel.habit.tasksNeeded,
                                format: .number
                            )
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .tint(.blue)
                        }
                        Picker("Unit", selection: $viewModel.habit.habitUnit) {
                            ForEach(viewModel.units.list, id: \.self) {
                                Text($0)
                            }
                        }
                        .tint(.secondary)
                    }
                    
                    Section("Reminders") {
                        Toggle("Enable reminders", isOn: $habit.reminderEnabled.animation())
                            .tint(.green)
                        
                        if habit.reminderEnabled {
                            DatePicker(
                                "Reminder time",
                                selection: $viewModel.habit.habitReminderTime,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }
                }
                .navigationTitle("Edit Habit")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .toolbar {
                    Button("Save") {
                        habit.objectWillChange.send()
                        viewModel.persistenceController.save()
                        dismiss()
                    }
                    .foregroundStyle(.blue)
                }
                .toolbarBackground(.hidden)
                .preferredColorScheme(.light)
                .alert("Oops!", isPresented: $viewModel.showingNotificationsError) {
                    Button("Check Settings") {
                        guard let settingsURL = viewModel.createAppSettingsURL() else { return }
                        openURL(settingsURL)
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("There was a problem setting your notification. Please check you have notifications enabled.")
                }
                .onChange(of: habit.reminderEnabled, initial: false) { _, _  in
                    viewModel.updateReminder()
                }
                .onChange(of: habit.reminderTime, initial: false) { _, _  in
                    viewModel.updateReminder()
                }
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    EditHabitView(habit: Habit.example(controller: persistenceController), persistenceController: persistenceController)
        .environmentObject(persistenceController)
}
