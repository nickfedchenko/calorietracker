//
//  MealData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.02.2023.
//

import Foundation

struct MealData {
    let id: String
    let weight: Double
    let food: Food?
    
    init(weight: Double, food: Food? = nil) {
        self.id = UUID().uuidString
        self.weight = weight
        self.food = food
    }
}

extension MealData {
    init?(from managedModel: DomainMealData) {
        self.id = managedModel.id
        self.weight = managedModel.weight
        
        if let domainProduct = managedModel.product,
           let product = Product(from: domainProduct) {
            if managedModel.unitId >= 0 && managedModel.unitCount >= 0 {
                let unit = product.units?.first(where: { $0.id == Int(managedModel.unitId) })?.convenientUnit
                ?? .gram(title: "gram", shortTitle: "g", coefficient: 1)
                self.food = .product(
                    product, customAmount: nil, unit: (unit: unit, count: managedModel.unitCount)
                )
            } else {
                self.food = .product(product, customAmount: managedModel.weight, unit: nil)
            }
        } else if let domainDish = managedModel.dish,
                  let dish = Dish(from: domainDish) {
            self.food = .dishes(dish, customAmount: managedModel.weight)
        } else if let domainCustomEntry = managedModel.customEntry,
                  let customEntry = CustomEntry(from: domainCustomEntry) {
            self.food = .customEntry(customEntry)
        } else if let domainMeal = managedModel.meal,
                  let meal = Meal(from: domainMeal) {
            self.food = .meal(meal)
        } else {
            self.food = nil
        }
    }
}
