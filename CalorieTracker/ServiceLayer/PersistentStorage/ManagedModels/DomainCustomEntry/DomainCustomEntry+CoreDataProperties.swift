//
//  DomainCustomEntry+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 20.02.2023.
//

import CoreData

extension DomainCustomEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainCustomEntry> {
        return NSFetchRequest<DomainCustomEntry>(entityName: "DomainCustomEntry")
    }

    @NSManaged public var carbs: Double
    @NSManaged public var fats: Double
    @NSManaged public var id: String
    @NSManaged public var kcal: Double
    @NSManaged public var mealTime: String
    @NSManaged public var proteins: Double
    @NSManaged public var title: String
    @NSManaged public var foodData: DomainFoodData?
    @NSManaged public var foodDataNew: NSOrderedSet?
    @NSManaged public var mealsData: DomainMealData?

}

// MARK: Generated accessors for foodDataNew
extension DomainCustomEntry {

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
