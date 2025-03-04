//
//  Persistence.swift
//  Habits
//
//  Created by Brendan Caporale on 3/1/25.
//

import CoreData
import SwiftUI

class PersistenceController: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var selectedHabit: Habit?
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Habits", managedObjectModel: Self.model)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static let preview: PersistenceController = {
        let persistanceController = PersistenceController(inMemory: true)
        persistanceController.createSampleData()
        return persistanceController
    }()
    
    func createSampleData() {
        let viewContext = container.viewContext
        
        let availableHabits = ["Brush Teeth", "Floss", "Feed Dog", "Walk Dog", "Take Medicine", "Make Bed"]
        
        for int in 0...4 {
            let newHabit = Habit(context: viewContext)
            newHabit.id = UUID()
            newHabit.title = availableHabits[int]
            newHabit.unit = "Count"
            newHabit.tasksNeeded = 2
        }
        
        try? viewContext.save()
    }
    
    func save() {
        try? container.viewContext.save()
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        delete(request1)

        save()
    }
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Habits", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()
}
