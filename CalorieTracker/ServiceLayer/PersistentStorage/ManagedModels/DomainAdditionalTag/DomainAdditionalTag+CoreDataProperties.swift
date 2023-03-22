//
//  DomainAdditionalTag+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

extension DomainAdditionalTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainAdditionalTag> {
        return NSFetchRequest<DomainAdditionalTag>(entityName: "DomainAdditionalTag")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var dishesAssigned: NSSet?

}

// MARK: Generated accessors for dishesAssigned
extension DomainAdditionalTag {

    @objc(addDishesAssignedObject:)
    @NSManaged public func addToDishesAssigned(_ value: DomainDish)

    @objc(removeDishesAssignedObject:)
    @NSManaged public func removeFromDishesAssigned(_ value: DomainDish)

    @objc(addDishesAssigned:)
    @NSManaged public func addToDishesAssigned(_ values: NSSet)

    @objc(removeDishesAssigned:)
    @NSManaged public func removeFromDishesAssigned(_ values: NSSet)

}
