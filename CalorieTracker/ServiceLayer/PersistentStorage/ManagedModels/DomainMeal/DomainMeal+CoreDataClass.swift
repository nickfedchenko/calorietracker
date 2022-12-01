//
//  DomainMeal+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.11.2022.
//

import CoreData

@objc(DomainMeal)
public class DomainMeal: NSManagedObject {
    static func prepare(fromPlainModel model: Meal, context: NSManagedObjectContext) -> DomainMeal {
        let meal = DomainMeal(context: context)
        meal.id = model.id
        meal.mealTime = model.mealTime.rawValue
        
        return meal
    }
}
