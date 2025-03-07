//
//  NewHabitView.swift
//  Habits
//
//  Created by Brendan Caporale on 3/2/25.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @StateObject private var viewModel: ViewModel
    
    init(persistenceController: PersistenceController) {
        let viewModel = ViewModel(persistenceController: persistenceController)
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
                                text: $viewModel.title,
                                prompt: Text("Enter the habit title here")
                            )
                            .multilineTextAlignment(.trailing)
                            .tint(.blue)
                        }
                        HStack {
                            Text("Amount")
                            TextField(
                                "Amount",
                                value: $viewModel.tasksNeeded,
                                format: .number
                            )
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .tint(.blue)
                        }
                        Picker("Unit", selection: $viewModel.unit) {
                            ForEach(viewModel.units.list, id: \.self) {
                                Text($0)
                            }
                        }
                        .tint(.secondary)
                        .accessibilityIdentifier("Unit")
                    }

                    Section("Reminders") {
                        Toggle("Enable reminders", isOn: $viewModel.reminderEnabled.animation())
                            .tint(.green)
                        
                        if viewModel.reminderEnabled {
                            DatePicker(
                                "Reminder time",
                                selection: $viewModel.reminderTime,
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }
                }
                .navigationTitle("New Habit")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .toolbarBackground(.hidden)
                .preferredColorScheme(.light)
                .toolbar {
                    Button("Save") {
                        viewModel.addHabit()
                        dismiss()
                    }
                    .tint(.blue)
                    .disabled(viewModel.disabledForm)
                }
                .alert("Oops!", isPresented: $viewModel.showingNotificationsError) {
                    Button("Check Settings") {
                        guard let settingsURL = viewModel.createAppSettingsURL() else { return }
                        openURL(settingsURL)
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("There was a problem setting your notification. Please check you have notifications enabled.")
                }
                .onChange(of: viewModel.reminderEnabled, initial: false) { _, _  in
                    viewModel.checkSettings()
                }
                .onChange(of: viewModel.reminderTime, initial: false) { _, _  in
                    viewModel.checkSettings()
                }
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    NewHabitView(persistenceController: .preview)
        .environmentObject(persistenceController)
}
