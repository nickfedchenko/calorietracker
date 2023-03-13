//
//  DomainMeal+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 12.03.2023.
//
//

import CoreData

@objc(DomainMeal)
public class DomainMeal: NSManagedObject {
    static func prepare(from plainModel: Meal, context: NSManagedObjectContext) -> DomainMeal {
        let storedMeal = DomainMeal(context: context)
        storedMeal.id = plainModel.id
        storedMeal.mealTime = plainModel.mealTime.rawValue
        storedMeal.title = plainModel.title
        storedMeal.photoURL = plainModel.photoURL
        
        for food in plainModel.foods {
            switch food {
            case .product(let product, let customAmount, let unit):
                let productId = product.id
                var amount: Double = 0
                var foodUnitID: Int?
                if let unit = unit {
                    foodUnitID = unit.unit.id
                    amount = unit.count
                }
                
                if let customAmount = customAmount {
                    amount = customAmount
                }
                let component = DomainMealComponent(context: context)
                component.productID = productId
                component.productAmount = amount
                component.productUnitID = Int32(foodUnitID ?? -1)
                storedMeal.addToComponents(component)
            case .dishes(let dish, let customAmount):
               let component = DomainMealComponent(context: context)
                component.dishID = String(dish.id)
                component.dishAmount = customAmount ?? 0
                storedMeal.addToComponents(component)
            case .meal(_):
                continue
            case .customEntry(let customEntry):
                let component = DomainMealComponent(context: context)
                component.customEntryID = customEntry.id
                storedMeal.addToComponents(component)
            }
        }
        return storedMeal
    }
}
