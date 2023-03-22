//
//  DomainDish+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 22.03.2023.
//
//

import CoreData

// swiftlint:disable:next function_body_length
@objc(DomainDish)
public class DomainDish: NSManagedObject {
    static func prepare(fromPlainModel model: Dish, context: NSManagedObjectContext) -> DomainDish {
        let dish = DomainDish(context: context)
        dish.id = Int16(model.id)
        dish.title = model.title
        dish.info = model.description
        dish.cookTime = Int16(model.cookTime)
        dish.kcal = model.kcal
        dish.protein = model.protein
        dish.fat = model.fat
        dish.carbs = model.carbs
        dish.photo = URL(string: model.photo)
        dish.weight = (model.dishWeight ?? -1) == -1 ? -1 : model.dishWeight ?? -1
        dish.servings = Int16(model.totalServings ?? 0)
        dish.updatedAt = model.createdAt
        dish.dishWeightType = Int16(model.dishWeightType ?? 1)
        
        if let countriesData = try? JSONEncoder().encode(model.countries) {
            dish.countries = countriesData
        }
        
        if let hundredValues = model.values?.hundred {
            dish.hundredValues = DomainPCFValues.prepare(
                from: hundredValues,
                purposeString: "hundreds",
                context: context,
                parentDishID: String(model.id)
            )
        }
        
        if let dishValues = model.values?.dish {
            dish.dishValues = DomainPCFValues.prepare(
                from: dishValues,
                purposeString: "dish",
                context: context,
                parentDishID: String(model.id)
            )
        }
        
        if let servingValues = model.values?.serving {
            dish.servingValues = DomainPCFValues.prepare(
                from: servingValues,
                purposeString: "serving",
                context: context,
                parentDishID: String(model.id)
            )
        }
        
        let ingredients: [DomainDishIngredient] = model
            .ingredients
            .compactMap { DomainDishIngredient.prepare(from: $0, context: context) }
        dish.addToIngredients(NSOrderedSet(array: ingredients))
        
        if let methodsData = try? JSONEncoder().encode(model.instructions) {
            dish.methods = methodsData
        }
        
        let eatingTags: [DomainEatingTag] = model
            .eatingTags
            .compactMap { DomainEatingTag.prepare(from: $0, context: context) }
        dish.addToEatingTags(NSOrderedSet(array: eatingTags))
        
        let dishTypeTags: [DomainDishTypeTag] = model
            .dishTypeTags
            .compactMap { DomainDishTypeTag.prepare(from: $0, context: context) }
        dish.addToDishTypeTags(NSOrderedSet(array: dishTypeTags))
        
        let processingTypeTags: [DomainProcessingTag] = model
            .processingTypeTags
            .compactMap { DomainProcessingTag.prepare(from: $0, context: context) }
        dish.addToProcessingTypeTags(NSOrderedSet(array: processingTypeTags))
        
        let additionalTags: [DomainAdditionalTag] = model
            .additionalTags
            .compactMap { DomainAdditionalTag.prepare(from: $0, context: context) }
        dish.addToAdditionalTags(NSOrderedSet(array: additionalTags))
        
        let dietTags: [DomainDietTag] = model
            .dietTags
            .compactMap { DomainDietTag.prepare(from: $0, context: context) }
        dish.addToDietTags(NSOrderedSet(array: dietTags))
        
        let exceptionTags: [DomainExceptionTag] = model
            .exceptionTags
            .compactMap { DomainExceptionTag.prepare(from: $0, context: context) }
        dish.addToExceptionTags(NSOrderedSet(array: exceptionTags))
        dish.foodData = nil
        return dish
    }
}
