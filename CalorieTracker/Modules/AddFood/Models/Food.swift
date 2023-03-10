//
//  Food.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.10.2022.
//

import Foundation
typealias FoodUnitData = (unit: UnitElement.ConvenientUnit, count: Double)
enum Food {
    case product(Product, customAmount: Double?, unit: FoodUnitData?)
    case dishes(Dish, customAmount: Double?)
    case meal(Meal)
    case customEntry(CustomEntry)
}

extension Food {
    var foodInfo: [FoodInfoCases: Double] {
        switch self {
        case .product(let product, let customAmount, let foodUnitData):
            return [
                .kcal: product.kcal * ((customAmount ?? 100) / 100),
                .carb: product.carbs * ((customAmount ?? 100) / 100),
                .fat: product.fat * ((customAmount ?? 100) / 100),
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
        case .meal(let meal):
            return [
                .kcal: meal.nutrients.kcal,
                .carb: meal.nutrients.carbs,
                .fat: meal.nutrients.fats,
                .protein: meal.nutrients.proteins
            ]
        case .customEntry(let customEntry):
            return [
                .kcal: customEntry.nutrients.kcal,
                .carb: customEntry.nutrients.carbs,
                .fat: customEntry.nutrients.fats,
                .protein: customEntry.nutrients.proteins
            ]
        }
    }
    
    var id: String {
        switch self {
        case .product(let product, _, _):
            return product.id
        case .dishes(let dish, _):
            return String(dish.id)
        case .meal(let meal):
            return meal.id
        case .customEntry(let customEntry):
            return customEntry.id
        }
    }
    
    var foodDataId: String? {
        switch self {
        case .product(let product, _, _):
            return product.foodDataId
        case .dishes(let dish, _):
            return dish.foodDataId
        case .meal(let meal):
            return meal.foodDataId
        case .customEntry(let customEntry):
            return customEntry.foodDataId
        }
    }
    
    var weight: Double? {
        switch self {
        case .product(_, let customAmount, _):
            return customAmount
        case .dishes(_, let customAmount):
            return customAmount
        case .meal:
            return nil
        case .customEntry:
            return nil
        }
    }
}

extension Food: Equatable {
    static func == (lhs: Food, rhs: Food) -> Bool {
        switch (lhs, rhs) {
        case let (.product(productLhs, _, _), .product(productRhs, _, _)):
            return productLhs == productRhs
        case let (.dishes(dishLhs, _), .dishes(dishRhs, _)):
            return dishLhs == dishRhs
        case let (.customEntry(customEntryLhs), .customEntry(customEntryRhs)):
            return customEntryLhs == customEntryRhs
        case let (.meal(mealLhs), .meal(mealRhs)):
            return mealLhs == mealRhs
        default:
            return false
        }
    }
}
