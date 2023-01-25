//
//  Food.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.10.2022.
//

import Foundation

enum Food {
    case product(Product)
    case dishes(Dish)
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
        case .dishes(let dish):
            return [
                .kcal: dish.kcal,
                .carb: dish.carbs,
                .fat: dish.fat,
                .protein: dish.protein
            ]
        case .meal:
            return [:]
        }
    }
    
    var id: String {
        switch self {
        case .product(let product):
            return product.id
        case .dishes(let dish):
            return String(dish.id)
        case .meal(let meal):
            return meal.id
        }
    }
    
    var foodDataId: String? {
        switch self {
        case .product(let product):
            return product.foodDataId
        case .dishes(let dish):
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
        case let (.dishes(dishLhs), .dishes(dishRhs)):
            return dishLhs == dishRhs
        default:
            return false
        }
    }
}
