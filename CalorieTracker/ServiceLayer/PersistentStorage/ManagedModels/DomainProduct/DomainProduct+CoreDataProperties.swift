//
//  DomainProduct+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 21.03.2023.
//
//

import CoreData

extension DomainProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainProduct> {
        return NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var brand: String?
    @NSManaged public var carbs: Double
    @NSManaged public var composition: Data?
    @NSManaged public var createdAt: String?
    @NSManaged public var fat: Double
    @NSManaged public var id: String
    @NSManaged public var isUserProduct: Bool
    @NSManaged public var kcal: Double
    @NSManaged public var ketoRating: String?
    @NSManaged public var photo: Data?
    @NSManaged public var productURL: Int16
    @NSManaged public var protein: Double
    @NSManaged public var servings: Data?
    @NSManaged public var source: String?
    @NSManaged public var title: String
    @NSManaged public var units: Data?
    @NSManaged public var exceptionTags: NSOrderedSet?
    @NSManaged public var foodData: DomainFoodData?
    @NSManaged public var mealsData: NSSet?
    @NSManaged public var foodDataNew: NSOrderedSet?
}

// MARK: Generated accessors for exceptionTags
extension DomainProduct {

    @objc(insertObject:inExceptionTagsAtIndex:)
    @NSManaged public func insertIntoExceptionTags(_ value: DomainExceptionTag, at idx: Int)

    @objc(removeObjectFromExceptionTagsAtIndex:)
    @NSManaged public func removeFromExceptionTags(at idx: Int)

    @objc(insertExceptionTags:atIndexes:)
    @NSManaged public func insertIntoExceptionTags(_ values: [DomainExceptionTag], at indexes: NSIndexSet)

    @objc(removeExceptionTagsAtIndexes:)
    @NSManaged public func removeFromExceptionTags(at indexes: NSIndexSet)

    @objc(replaceObjectInExceptionTagsAtIndex:withObject:)
    @NSManaged public func replaceExceptionTags(at idx: Int, with value: DomainExceptionTag)

    @objc(replaceExceptionTagsAtIndexes:withExceptionTags:)
    @NSManaged public func replaceExceptionTags(at indexes: NSIndexSet, with values: [DomainExceptionTag])

    @objc(addExceptionTagsObject:)
    @NSManaged public func addToExceptionTags(_ value: DomainExceptionTag)

    @objc(removeExceptionTagsObject:)
    @NSManaged public func removeFromExceptionTags(_ value: DomainExceptionTag)

    @objc(addExceptionTags:)
    @NSManaged public func addToExceptionTags(_ values: NSOrderedSet)

    @objc(removeExceptionTags:)
    @NSManaged public func removeFromExceptionTags(_ values: NSOrderedSet)

}

// MARK: Generated accessors for mealsData
extension DomainProduct {

    @objc(addMealsDataObject:)
    @NSManaged public func addToMealsData(_ value: DomainMealData)

    @objc(removeMealsDataObject:)
    @NSManaged public func removeFromMealsData(_ value: DomainMealData)

    @objc(addMealsData:)
    @NSManaged public func addToMealsData(_ values: NSSet)

    @objc(removeMealsData:)
    @NSManaged public func removeFromMealsData(_ values: NSSet)

}

// MARK: Generated accessors for foodDataNew
extension DomainProduct {

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
