//
//  DailyMeal.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.02.2023.
//

import Foundation

struct DailyMeal {
    let date: Day
    let mealTime: MealTime
    let foods: [Food]
}

extension DailyMeal {
    init?(from managedModel: DomainDailyMeals) {
        self.date = .init(
            day: Int(managedModel.day),
            month: Int(managedModel.month),
            year: Int(managedModel.year)
        )
        
        self.mealTime = .init(rawValue: managedModel.mealTime) ?? .breakfast
        
        if let products = managedModel.products, let dishes = managedModel.dishes {
            let productFoods = products.compactMap { Product(from: $0) }.foods
            let dishFoods = dishes.compactMap { Dish(from: $0) }.foods
            self.foods = productFoods + dishFoods
        } else {
            self.foods = []
        }
    }
}
