//
//  CoreDataManager.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    private var persistentContainer: NSPersistentContainer!

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {}

    func prepare() {
        persistentContainer = NSPersistentContainer(name: "MC_Delivery")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
                fatalError()
            }
        }
    }

    func saveContext() {
        do {
            if persistentContainer.viewContext.hasChanges {
                try persistentContainer.viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


