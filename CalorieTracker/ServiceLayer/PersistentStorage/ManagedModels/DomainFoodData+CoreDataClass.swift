//
//  DomainFoodData+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.11.2022.
//

import CoreData

@objc(DomainFoodData)
public class DomainFoodData: NSManagedObject {
    static func prepare(fromPlainModel model: FoodData, context: NSManagedObjectContext) -> DomainFoodData {
        let foodData = DomainFoodData(context: context)
        foodData.id = Int32(model.id)
        foodData.numberUses = Int32(model.numberUses)
        foodData.favorites = model.favorites
        foodData.dateLastUse = model.dateLastUse
        
        return foodData
    }
}
