//
//  ContentViewRow.swift
//  Habits
//
//  Created by Brendan Caporale on 3/4/25.
//

import SwiftUI

struct ContentViewRow: View {
    @StateObject private var viewModel: ViewModel
    
    @ObservedObject var habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
        let viewModel = ViewModel(habit: habit)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(habit.habitTitle)
                    .font(.system(
                        size: Numbers.habitTitleFontSize,
                        weight: .bold,
                        design: .default)
                    )
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Progress:")
                    .font(.headline)
                    .foregroundStyle(.white)
                HStack {
                    Text("\(habit.tasksCompleted)/\(habit.tasksNeeded)")
                        .foregroundStyle(.white)
                    Text(LocalizedStringKey(viewModel.convertToPlural(habit: habit)))
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    let persistenceController = PersistenceController()
    
    ContentViewRow(habit: Habit.example(controller: persistenceController))
        .background(.green)
        .environmentObject(persistenceController)
}
