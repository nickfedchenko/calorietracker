//
//  DomainDish+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 12.08.2022.
//
//

import CoreData

@objc(DomainDish)
public class DomainDish: NSManagedObject {
    static func prepare(fromPlainModel model: Dish, context: NSManagedObjectContext) -> DomainDish {
        let dish = DomainDish(context: context)
        dish.id = Int16(model.id)
        dish.title = model.title
        dish.info = model.info
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
        
        if let servingValues = model.values?.serving,
            let servingValuesData = try? JSONEncoder().encode(servingValues) {
            dish.servingValues = servingValuesData
        }
        
        if let hundredValues = model.values?.hundred,
            let hundredValuesData = try? JSONEncoder().encode(hundredValues) {
            dish.hundredValues = hundredValuesData
        }
        
        if let dishValues = model.values?.dish,
            let dishValuesData = try? JSONEncoder().encode(dishValues) {
            dish.dishValues = dishValuesData
        }
        
        if let countriesData = try? JSONEncoder().encode(model.countries) {
            dish.countries = countriesData
        }
        
        if let ingredientsData = try? JSONEncoder().encode(model.ingredients) {
            dish.ingredients = ingredientsData
        }
        
        if let methodsData = try? JSONEncoder().encode(model.instructions) {
            dish.methods = methodsData
        }
        
        if let eatingTagsData = try? JSONEncoder().encode(model.eatingTags) {
            dish.eatingTags = eatingTagsData
        }
        
        if let dishTypeTags = try? JSONEncoder().encode(model.dishTypeTags) {
            dish.dishTypeTags = dishTypeTags
        }
        
        if let processingTypeTags = try? JSONEncoder().encode(model.processingTypeTags) {
            dish.processingTypeTags = processingTypeTags
        }
        
        if let additionalTags = try? JSONEncoder().encode(model.additionalTags) {
            dish.additionalTags = additionalTags
        }
        
        if let dietTags = try? JSONEncoder().encode(model.dietTags) {
            dish.dietTags = dietTags
        }
        
        if let exceptionTags = try? JSONEncoder().encode(model.exceptionTags) {
            dish.exceptionTags = exceptionTags
        }
        
        return dish
    }
}
