//
//  DomainProduct+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 21.03.2023.
//
//

import Foundation
import CoreData


extension DomainProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainProduct> {
        return NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var brand: String?
    @NSManaged public var carbs: Double
    @NSManaged public var composition: Data?
    @NSManaged public var fat: Double
    @NSManaged public var id: String
    @NSManaged public var isUserProduct: Bool
    @NSManaged public var kcal: Double
    @NSManaged public var photo: Data?
    @NSManaged public var protein: Double
    @NSManaged public var servings: Data?
    @NSManaged public var title: String
    @NSManaged public var units: Data?
    @NSManaged public var productURL: Int16
    @NSManaged public var ketoRating: String?
    @NSManaged public var foodData: DomainFoodData?
    @NSManaged public var meal: DomainMeal?
    @NSManaged public var mealsData: NSSet?
    @NSManaged public var exceptionTags: NSOrderedSet?
    @NSManaged public  var createdAt: String?

}

// MARK: - Generated accessors for mealsData
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

// MARK: - Generated accessors for exceptionTags
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
