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
        dish.kcal = Int16(model.kсal)
        dish.protein = model.protein
        dish.fat = model.fat
        dish.carbs = model.carbs
        dish.photo = model.photo
        dish.weight = (model.weight ?? -1) == -1 ? -1 : Int16(model.weight!)
        dish.servings = (model.weight ?? -1) == -1 ? -1 : Int16(model.servings!)
        dish.videoURL = model.videoURL
        dish.updatedAt = model.updatedAt
        if let ingredientsData = try? JSONEncoder().encode(model.ingredients) {
            dish.ingredients = ingredientsData
        }
        
        if let methodsData = try? JSONEncoder().encode(model.methods) {
            dish.methods = methodsData
        }
        
        if let tagsData = try? JSONEncoder().encode(model.tags) {
            dish.tags = tagsData
        }
        
        if let photosData = try? JSONEncoder().encode(model.photos) {
            dish.photos = photosData
        }
        
        return dish
    }
}
