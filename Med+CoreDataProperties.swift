//
//  Med+CoreDataProperties.swift
//  MC Delivery
//
//  Created by Lin Thit Khant on 3/6/23.
//
//

import Foundation
import CoreData


extension Med {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Med> {
        return NSFetchRequest<Med>(entityName: "Med")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var pictureUrls: String?
    @NSManaged public var price: Int64
    @NSManaged public var quantity: Int16

}

extension Med : Identifiable {

}
