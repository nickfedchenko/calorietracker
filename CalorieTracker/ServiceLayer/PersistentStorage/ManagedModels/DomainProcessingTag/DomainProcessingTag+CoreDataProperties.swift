//
//  DomainProcessingTag+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import Foundation
import CoreData


extension DomainProcessingTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainProcessingTag> {
        return NSFetchRequest<DomainProcessingTag>(entityName: "DomainProcessingTag")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var dishesAssigned: NSSet?

}

// MARK: Generated accessors for dishesAssigned
extension DomainProcessingTag {

    @objc(addDishesAssignedObject:)
    @NSManaged public func addToDishesAssigned(_ value: DomainDish)

    @objc(removeDishesAssignedObject:)
    @NSManaged public func removeFromDishesAssigned(_ value: DomainDish)

    @objc(addDishesAssigned:)
    @NSManaged public func addToDishesAssigned(_ values: NSSet)

    @objc(removeDishesAssigned:)
    @NSManaged public func removeFromDishesAssigned(_ values: NSSet)

}
