//
//  DomainExceptionTag+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 21.03.2023.
//
//

import CoreData

extension DomainExceptionTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainExceptionTag> {
        return NSFetchRequest<DomainExceptionTag>(entityName: "DomainExceptionTag")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var dishesAssigned: NSOrderedSet?
    @NSManaged public var productsAssigned: NSOrderedSet?
}

// MARK: - Generated accessors for dishesAssigned
extension DomainExceptionTag {

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

// MARK: Generated accessors for productsAssigned
extension DomainExceptionTag {

    @objc(insertObject:inProductsAssignedAtIndex:)
    @NSManaged public func insertIntoProductsAssigned(_ value: DomainProduct, at idx: Int)

    @objc(removeObjectFromProductsAssignedAtIndex:)
    @NSManaged public func removeFromProductsAssigned(at idx: Int)

    @objc(insertProductsAssigned:atIndexes:)
    @NSManaged public func insertIntoProductsAssigned(_ values: [DomainProduct], at indexes: NSIndexSet)

    @objc(removeProductsAssignedAtIndexes:)
    @NSManaged public func removeFromProductsAssigned(at indexes: NSIndexSet)

    @objc(replaceObjectInProductsAssignedAtIndex:withObject:)
    @NSManaged public func replaceProductsAssigned(at idx: Int, with value: DomainProduct)

    @objc(replaceProductsAssignedAtIndexes:withProductsAssigned:)
    @NSManaged public func replaceProductsAssigned(at indexes: NSIndexSet, with values: [DomainProduct])

    @objc(addProductsAssignedObject:)
    @NSManaged public func addToProductsAssigned(_ value: DomainProduct)

    @objc(removeProductsAssignedObject:)
    @NSManaged public func removeFromProductsAssigned(_ value: DomainProduct)

    @objc(addProductsAssigned:)
    @NSManaged public func addToProductsAssigned(_ values: NSOrderedSet)

    @objc(removeProductsAssigned:)
    @NSManaged public func removeFromProductsAssigned(_ values: NSOrderedSet)

}
