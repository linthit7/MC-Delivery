//
//  ShoppingCart.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//

import Foundation
import CoreData

struct ShoppingCart {
    
    static let sharedInstance = ShoppingCart()
    
    let managedContext = CoreDataManager.sharedManager.context
    
    func saveItemToPersistentStore(item: Medicine, quantity: Int = 1) {
        
        let pictureUrl = item.pictureUrls[0].stringValue
        
        guard let medEntity = NSEntityDescription.entity(forEntityName: "Med", in: managedContext) else {return}
        
        let nsMed = NSManagedObject(entity: medEntity, insertInto: managedContext)
        nsMed.setValue(item._id, forKey: "id")
        nsMed.setValue(item.name, forKey: "name")
        nsMed.setValue(item.price, forKey: "price")
        nsMed.setValue(quantity, forKey: "quantity")
        nsMed.setValue(pictureUrl, forKey: "pictureUrls")
        
        do {
            try managedContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func removeItemFromPersistentStore(item: Med) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Med")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(item.id!)")
        
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [Med] else {return}
            guard let item = result.first else {return}
            managedContext.delete(item)
            
            do {
                try managedContext.save()
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchAllItem() -> [Med]? {
        
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Med")
        
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [Med] else {return nil}
            return result
        } catch let error {
            print(error)
        }
        return nil
    }
    
}
