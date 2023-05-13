//
//  DomainDish+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 22.03.2023.
//
//

import CoreData

extension DomainDish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainDish> {
        return NSFetchRequest<DomainDish>(entityName: "DomainDish")
    }

    @NSManaged public var carbs: Double
    @NSManaged public var cookTime: Int16
    @NSManaged public var countries: Data?
    @NSManaged public var dishWeightType: Int16
    @NSManaged public var fat: Double
    @NSManaged public var id: Int16
    @NSManaged public var info: String?
    @NSManaged public var kcal: Double
    @NSManaged public var methods: Data?
    @NSManaged public var photo: URL?
    @NSManaged public var protein: Double
    @NSManaged public var servings: Int16
    @NSManaged public var title: String
    @NSManaged public var updatedAt: String
    @NSManaged public var weight: Double
    @NSManaged public var additionalTags: NSOrderedSet?
    @NSManaged public var dietTags: NSOrderedSet?
    @NSManaged public var dishTypeTags: NSOrderedSet?
    @NSManaged public var dishValues: DomainPCFValues?
    @NSManaged public var eatingTags: NSOrderedSet?
    @NSManaged public var exceptionTags: NSOrderedSet?
    @NSManaged public var foodData: DomainFoodData?
    @NSManaged public var foodDataNew: NSOrderedSet?
    @NSManaged public var hundredValues: DomainPCFValues?
    @NSManaged public var ingredients: NSOrderedSet?
    @NSManaged public var mealsData: NSSet?
    @NSManaged public var processingTypeTags: NSOrderedSet?
    @NSManaged public var servingValues: DomainPCFValues?

}

// MARK: Generated accessors for additionalTags
extension DomainDish {

    @objc(insertObject:inAdditionalTagsAtIndex:)
    @NSManaged public func insertIntoAdditionalTags(_ value: DomainAdditionalTag, at idx: Int)

    @objc(removeObjectFromAdditionalTagsAtIndex:)
    @NSManaged public func removeFromAdditionalTags(at idx: Int)

    @objc(insertAdditionalTags:atIndexes:)
    @NSManaged public func insertIntoAdditionalTags(_ values: [DomainAdditionalTag], at indexes: NSIndexSet)

    @objc(removeAdditionalTagsAtIndexes:)
    @NSManaged public func removeFromAdditionalTags(at indexes: NSIndexSet)

    @objc(replaceObjectInAdditionalTagsAtIndex:withObject:)
    @NSManaged public func replaceAdditionalTags(at idx: Int, with value: DomainAdditionalTag)

    @objc(replaceAdditionalTagsAtIndexes:withAdditionalTags:)
    @NSManaged public func replaceAdditionalTags(at indexes: NSIndexSet, with values: [DomainAdditionalTag])

    @objc(addAdditionalTagsObject:)
    @NSManaged public func addToAdditionalTags(_ value: DomainAdditionalTag)

    @objc(removeAdditionalTagsObject:)
    @NSManaged public func removeFromAdditionalTags(_ value: DomainAdditionalTag)

    @objc(addAdditionalTags:)
    @NSManaged public func addToAdditionalTags(_ values: NSOrderedSet)

    @objc(removeAdditionalTags:)
    @NSManaged public func removeFromAdditionalTags(_ values: NSOrderedSet)

}

// MARK: Generated accessors for dietTags
extension DomainDish {

    @objc(insertObject:inDietTagsAtIndex:)
    @NSManaged public func insertIntoDietTags(_ value: DomainDietTag, at idx: Int)

    @objc(removeObjectFromDietTagsAtIndex:)
    @NSManaged public func removeFromDietTags(at idx: Int)

    @objc(insertDietTags:atIndexes:)
    @NSManaged public func insertIntoDietTags(_ values: [DomainDietTag], at indexes: NSIndexSet)

    @objc(removeDietTagsAtIndexes:)
    @NSManaged public func removeFromDietTags(at indexes: NSIndexSet)

    @objc(replaceObjectInDietTagsAtIndex:withObject:)
    @NSManaged public func replaceDietTags(at idx: Int, with value: DomainDietTag)

    @objc(replaceDietTagsAtIndexes:withDietTags:)
    @NSManaged public func replaceDietTags(at indexes: NSIndexSet, with values: [DomainDietTag])

    @objc(addDietTagsObject:)
    @NSManaged public func addToDietTags(_ value: DomainDietTag)

    @objc(removeDietTagsObject:)
    @NSManaged public func removeFromDietTags(_ value: DomainDietTag)

    @objc(addDietTags:)
    @NSManaged public func addToDietTags(_ values: NSOrderedSet)

    @objc(removeDietTags:)
    @NSManaged public func removeFromDietTags(_ values: NSOrderedSet)

}

// MARK: Generated accessors for dishTypeTags
extension DomainDish {

    @objc(insertObject:inDishTypeTagsAtIndex:)
    @NSManaged public func insertIntoDishTypeTags(_ value: DomainDishTypeTag, at idx: Int)

    @objc(removeObjectFromDishTypeTagsAtIndex:)
    @NSManaged public func removeFromDishTypeTags(at idx: Int)

    @objc(insertDishTypeTags:atIndexes:)
    @NSManaged public func insertIntoDishTypeTags(_ values: [DomainDishTypeTag], at indexes: NSIndexSet)

    @objc(removeDishTypeTagsAtIndexes:)
    @NSManaged public func removeFromDishTypeTags(at indexes: NSIndexSet)

    @objc(replaceObjectInDishTypeTagsAtIndex:withObject:)
    @NSManaged public func replaceDishTypeTags(at idx: Int, with value: DomainDishTypeTag)

    @objc(replaceDishTypeTagsAtIndexes:withDishTypeTags:)
    @NSManaged public func replaceDishTypeTags(at indexes: NSIndexSet, with values: [DomainDishTypeTag])

    @objc(addDishTypeTagsObject:)
    @NSManaged public func addToDishTypeTags(_ value: DomainDishTypeTag)

    @objc(removeDishTypeTagsObject:)
    @NSManaged public func removeFromDishTypeTags(_ value: DomainDishTypeTag)

    @objc(addDishTypeTags:)
    @NSManaged public func addToDishTypeTags(_ values: NSOrderedSet)

    @objc(removeDishTypeTags:)
    @NSManaged public func removeFromDishTypeTags(_ values: NSOrderedSet)

}

// MARK: Generated accessors for eatingTags
extension DomainDish {

    @objc(insertObject:inEatingTagsAtIndex:)
    @NSManaged public func insertIntoEatingTags(_ value: DomainEatingTag, at idx: Int)

    @objc(removeObjectFromEatingTagsAtIndex:)
    @NSManaged public func removeFromEatingTags(at idx: Int)

    @objc(insertEatingTags:atIndexes:)
    @NSManaged public func insertIntoEatingTags(_ values: [DomainEatingTag], at indexes: NSIndexSet)

    @objc(removeEatingTagsAtIndexes:)
    @NSManaged public func removeFromEatingTags(at indexes: NSIndexSet)

    @objc(replaceObjectInEatingTagsAtIndex:withObject:)
    @NSManaged public func replaceEatingTags(at idx: Int, with value: DomainEatingTag)

    @objc(replaceEatingTagsAtIndexes:withEatingTags:)
    @NSManaged public func replaceEatingTags(at indexes: NSIndexSet, with values: [DomainEatingTag])

    @objc(addEatingTagsObject:)
    @NSManaged public func addToEatingTags(_ value: DomainEatingTag)

    @objc(removeEatingTagsObject:)
    @NSManaged public func removeFromEatingTags(_ value: DomainEatingTag)

    @objc(addEatingTags:)
    @NSManaged public func addToEatingTags(_ values: NSOrderedSet)

    @objc(removeEatingTags:)
    @NSManaged public func removeFromEatingTags(_ values: NSOrderedSet)

}

// MARK: Generated accessors for exceptionTags
extension DomainDish {

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

// MARK: Generated accessors for foodDataNew
extension DomainDish {

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

// MARK: Generated accessors for ingredients
extension DomainDish {

    @objc(insertObject:inIngredientsAtIndex:)
    @NSManaged public func insertIntoIngredients(_ value: DomainDishIngredient, at idx: Int)

    @objc(removeObjectFromIngredientsAtIndex:)
    @NSManaged public func removeFromIngredients(at idx: Int)

    @objc(insertIngredients:atIndexes:)
    @NSManaged public func insertIntoIngredients(_ values: [DomainDishIngredient], at indexes: NSIndexSet)

    @objc(removeIngredientsAtIndexes:)
    @NSManaged public func removeFromIngredients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngredientsAtIndex:withObject:)
    @NSManaged public func replaceIngredients(at idx: Int, with value: DomainDishIngredient)

    @objc(replaceIngredientsAtIndexes:withIngredients:)
    @NSManaged public func replaceIngredients(at indexes: NSIndexSet, with values: [DomainDishIngredient])

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: DomainDishIngredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: DomainDishIngredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSOrderedSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSOrderedSet)

}

// MARK: Generated accessors for mealsData
extension DomainDish {

    @objc(addMealsDataObject:)
    @NSManaged public func addToMealsData(_ value: DomainMealData)

    @objc(removeMealsDataObject:)
    @NSManaged public func removeFromMealsData(_ value: DomainMealData)

    @objc(addMealsData:)
    @NSManaged public func addToMealsData(_ values: NSSet)

    @objc(removeMealsData:)
    @NSManaged public func removeFromMealsData(_ values: NSSet)

}

// MARK: Generated accessors for processingTypeTags
extension DomainDish {

    @objc(insertObject:inProcessingTypeTagsAtIndex:)
    @NSManaged public func insertIntoProcessingTypeTags(_ value: DomainProcessingTag, at idx: Int)

    @objc(removeObjectFromProcessingTypeTagsAtIndex:)
    @NSManaged public func removeFromProcessingTypeTags(at idx: Int)

    @objc(insertProcessingTypeTags:atIndexes:)
    @NSManaged public func insertIntoProcessingTypeTags(_ values: [DomainProcessingTag], at indexes: NSIndexSet)

    @objc(removeProcessingTypeTagsAtIndexes:)
    @NSManaged public func removeFromProcessingTypeTags(at indexes: NSIndexSet)

    @objc(replaceObjectInProcessingTypeTagsAtIndex:withObject:)
    @NSManaged public func replaceProcessingTypeTags(at idx: Int, with value: DomainProcessingTag)

    @objc(replaceProcessingTypeTagsAtIndexes:withProcessingTypeTags:)
    @NSManaged public func replaceProcessingTypeTags(at indexes: NSIndexSet, with values: [DomainProcessingTag])

    @objc(addProcessingTypeTagsObject:)
    @NSManaged public func addToProcessingTypeTags(_ value: DomainProcessingTag)

    @objc(removeProcessingTypeTagsObject:)
    @NSManaged public func removeFromProcessingTypeTags(_ value: DomainProcessingTag)

    @objc(addProcessingTypeTags:)
    @NSManaged public func addToProcessingTypeTags(_ values: NSOrderedSet)

    @objc(removeProcessingTypeTags:)
    @NSManaged public func removeFromProcessingTypeTags(_ values: NSOrderedSet)
}
