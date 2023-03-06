//
//  CoreDataManager.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import Foundation
import CoreData

//class CoreDataManager {
//
//    static let sharedManager = CoreDataManager()
//
//    private init() {}
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "MC_Delivery")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    func saveContext () {
//        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//}

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


