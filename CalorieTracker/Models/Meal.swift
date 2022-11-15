//
//  Meal.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.11.2022.
//

import Foundation

struct Meal {
    let id: String
    let mealTime: MealTime
    let products: [Product]
    let dishes: [Dish]
    
    init?(from managedModel: DomainMeal) {
        self.id = managedModel.id
        self.products = managedModel.products?
            .compactMap { $0 as? DomainProduct }
            .compactMap { Product(from: $0) } ?? []
        self.dishes = managedModel.dishes?
            .compactMap { $0 as? DomainDish }
            .compactMap { Dish(from: $0) } ?? []
        
        switch managedModel.mealTime {
        case MealTime.breakfast.rawValue:
            self.mealTime = .breakfast
        case MealTime.dinner.rawValue:
            self.mealTime = .dinner
        case MealTime.launch.rawValue:
            self.mealTime = .launch
        case MealTime.snack.rawValue:
            self.mealTime = .snack
        default:
            self.mealTime = .breakfast
        }
    }
    
    init(mealTime: MealTime) {
        self.mealTime = mealTime
        self.products = []
        self.dishes = []
        self.id = UUID().uuidString
    }
}

enum MealTime: String {
    case breakfast
    case launch
    case dinner
    case snack
}

extension Meal {
    func setChild(dishes: [Dish], products: [Product]) {
        DSF.shared.setChildMeal(
            mealId: self.id,
            dishesID: dishes.map { $0.id },
            productsID: products.map { $0.id }
        )
    }
}
