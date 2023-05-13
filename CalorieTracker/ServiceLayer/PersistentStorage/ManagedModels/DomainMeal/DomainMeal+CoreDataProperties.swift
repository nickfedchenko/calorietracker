//
//  DomainMeal+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 12.03.2023.
//
//

import Foundation
import CoreData


extension DomainMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainMeal> {
        return NSFetchRequest<DomainMeal>(entityName: "DomainMeal")
    }

    @NSManaged public var id: String?
    @NSManaged public var mealTime: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var title: String?
    @NSManaged public var components: NSOrderedSet?
    @NSManaged public var foodData: DomainFoodData?
    @NSManaged public var foodDataNew: NSOrderedSet?
    @NSManaged public var mealData: DomainMealData?

}

// MARK: Generated accessors for components
extension DomainMeal {

    @objc(insertObject:inComponentsAtIndex:)
    @NSManaged public func insertIntoComponents(_ value: DomainMealComponent, at idx: Int)

    @objc(removeObjectFromComponentsAtIndex:)
    @NSManaged public func removeFromComponents(at idx: Int)

    @objc(insertComponents:atIndexes:)
    @NSManaged public func insertIntoComponents(_ values: [DomainMealComponent], at indexes: NSIndexSet)

    @objc(removeComponentsAtIndexes:)
    @NSManaged public func removeFromComponents(at indexes: NSIndexSet)

    @objc(replaceObjectInComponentsAtIndex:withObject:)
    @NSManaged public func replaceComponents(at idx: Int, with value: DomainMealComponent)

    @objc(replaceComponentsAtIndexes:withComponents:)
    @NSManaged public func replaceComponents(at indexes: NSIndexSet, with values: [DomainMealComponent])

    @objc(addComponentsObject:)
    @NSManaged public func addToComponents(_ value: DomainMealComponent)

    @objc(removeComponentsObject:)
    @NSManaged public func removeFromComponents(_ value: DomainMealComponent)

    @objc(addComponents:)
    @NSManaged public func addToComponents(_ values: NSOrderedSet)

    @objc(removeComponents:)
    @NSManaged public func removeFromComponents(_ values: NSOrderedSet)

}

// MARK: Generated accessors for foodDataNew
extension DomainMeal {

    @objc(insertObject:inFoodDataNewAtIndex:)
    @NSManaged public func insertIntoFoodDataNew(_ value: DomainFoodDataNew, at idx: Int)

    @objc(removeObjectFromFoodDataNewAtIndex:)
    @NSManaged public func removeFromFoodDataNew(at idx: Int)

    @objc(insertFoodDataNew:atIndexes:)
    @NSManaged public func insertIntoFoodDataNew(_ values: [DomainFoodDataNew], at indexes: NSIndexSet)

    @objc(removeFoodDataNewAtIndexes:)
    @NSManaged public func removeFromFoodDataNew(at indexes: NSIndexSet)

    @objc(replaceObjectInFoodDataNewAtIndex:withObject:)
    @NSManaged public func replaceFoodDataNew(at idx: Int, with value: DomainFoodDataNew)

    @objc(replaceFoodDataNewAtIndexes:withFoodDataNew:)
    @NSManaged public func replaceFoodDataNew(at indexes: NSIndexSet, with values: [DomainFoodDataNew])

    @objc(addFoodDataNewObject:)
    @NSManaged public func addToFoodDataNew(_ value: DomainFoodDataNew)

    @objc(removeFoodDataNewObject:)
    @NSManaged public func removeFromFoodDataNew(_ value: DomainFoodDataNew)

    @objc(addFoodDataNew:)
    @NSManaged public func addToFoodDataNew(_ values: NSOrderedSet)

    @objc(removeFoodDataNew:)
    @NSManaged public func removeFromFoodDataNew(_ values: NSOrderedSet)

}
