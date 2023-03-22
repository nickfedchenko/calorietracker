//
//  DomainDishTypeTag+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 20.03.2023.
//
//

import CoreData

extension DomainDishTypeTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainDishTypeTag> {
        return NSFetchRequest<DomainDishTypeTag>(entityName: "DomainDishTypeTag")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var dishesAssigned: NSOrderedSet?

}

// MARK: - Generated accessors for dishesAssigned
extension DomainDishTypeTag {

    @objc(insertObject:inDishesAssignedAtIndex:)
    @NSManaged public func insertIntoDishesAssigned(_ value: DomainDish, at idx: Int)

    @objc(removeObjectFromDishesAssignedAtIndex:)
    @NSManaged public func removeFromDishesAssigned(at idx: Int)

    @objc(insertDishesAssigned:atIndexes:)
    @NSManaged public func insertIntoDishesAssigned(_ values: [DomainDish], at indexes: NSIndexSet)

    @objc(removeDishesAssignedAtIndexes:)
    @NSManaged public func removeFromDishesAssigned(at indexes: NSIndexSet)

    @objc(replaceObjectInDishesAssignedAtIndex:withObject:)
    @NSManaged public func replaceDishesAssigned(at idx: Int, with value: DomainDish)

    @objc(replaceDishesAssignedAtIndexes:withDishesAssigned:)
    @NSManaged public func replaceDishesAssigned(at indexes: NSIndexSet, with values: [DomainDish])

    @objc(addDishesAssignedObject:)
    @NSManaged public func addToDishesAssigned(_ value: DomainDish)

    @objc(removeDishesAssignedObject:)
    @NSManaged public func removeFromDishesAssigned(_ value: DomainDish)

    @objc(addDishesAssigned:)
    @NSManaged public func addToDishesAssigned(_ values: NSOrderedSet)

    @objc(removeDishesAssigned:)
    @NSManaged public func removeFromDishesAssigned(_ values: NSOrderedSet)

}
