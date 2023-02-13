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
            self.food = .product(product, customAmount: managedModel.weight)
        } else if let domainDish = managedModel.dish,
                  let dish = Dish(from: domainDish) {
            self.food = .dishes(dish, customAmount: managedModel.weight)
        } else {
            self.food = nil
        }
    }
}
