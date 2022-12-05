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
    case userProduct(UserProduct)
    case meal(Meal)
}

extension Food {
    var foodInfo: [FoodInfoCases: Int] {
        switch self {
        case .product(let product):
            return [
                .kcal: product.kcal,
                .carb: Int(product.carbs),
                .fat: Int(product.fat),
                .protein: Int(product.protein)
            ]
        case .dishes(let dish):
            return [
                .kcal: dish.kсal,
                .carb: Int(dish.carbs),
                .fat: Int(dish.fat),
                .protein: Int(dish.protein)
            ]
        case .userProduct:
            return [:]
        case .meal:
            return [:]
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