//
//  Food.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.10.2022.
//

import Foundation

enum Food {
    case product(Product)
    case dishes(Dish, customAmount: Double?)
    case meal(Meal)
}

extension Food {
    var foodInfo: [FoodInfoCases: Double] {
        switch self {
        case .product(let product):
            return [
                .kcal: product.kcal,
                .carb: product.carbs,
                .fat: product.fat,
                .protein: product.protein
            ]
        case .dishes(let dish, let amount):
            if let amount = amount {
                let ratio = amount / Double(dish.dishWeight ?? 1)
                return [
                    .kcal: dish.kcal * ratio,
                    .carb: dish.carbs * ratio,
                    .fat: dish.fat * ratio,
                    .protein: dish.protein * ratio
                ]
            } else {
                return [
                    .kcal: dish.kcal,
                    .carb: dish.carbs,
                    .fat: dish.fat,
                    .protein: dish.protein
                ]
            }
        case .meal:
            return [:]
        }
    }
    
    var id: String {
        switch self {
        case .product(let product):
            return product.id
        case .dishes(let dish, _):
            return String(dish.id)
        case .meal(let meal):
            return meal.id
        }
    }
    
    var foodDataId: String? {
        switch self {
        case .product(let product):
            return product.foodDataId
        case .dishes(let dish, _):
            return dish.foodDataId
        case .meal(let meal):
            return nil
        }
    }
}

extension Food: Equatable {
    static func == (lhs: Food, rhs: Food) -> Bool {
        switch (lhs, rhs) {
        case let (.product(productLhs), .product(productRhs)):
            return productLhs == productRhs
        case let (.dishes(dishLhs, _), .dishes(dishRhs, _)):
            return dishLhs == dishRhs
        default:
            return false
        }
    }
}
