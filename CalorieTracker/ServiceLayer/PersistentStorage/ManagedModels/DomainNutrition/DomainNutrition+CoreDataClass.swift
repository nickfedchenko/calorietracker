//
//  DomainNutrition+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.12.2022.
//

import CoreData

@objc(DomainNutrition)
public class DomainNutrition: NSManagedObject {
    static func prepare(fromPlainModel model: DailyNutritionData, context: NSManagedObjectContext) -> DomainNutrition {
        let nutrition = DomainNutrition(context: context)
        nutrition.day = Int32(model.day.day)
        nutrition.month = Int32(model.day.month)
        nutrition.year = Int32(model.day.year)
        nutrition.fat = model.nutrition.fat
        nutrition.kcal = model.nutrition.kcal
        nutrition.protein = model.nutrition.protein
        nutrition.carbs = model.nutrition.carbs
        return nutrition
    }
}
