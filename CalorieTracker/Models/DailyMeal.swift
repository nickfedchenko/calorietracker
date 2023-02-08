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
    let mealData: [MealData]
}

extension DailyMeal {
    init?(from managedModel: DomainDailyMeals) {
        self.date = .init(
            day: Int(managedModel.day),
            month: Int(managedModel.month),
            year: Int(managedModel.year)
        )
        
        self.mealTime = .init(rawValue: managedModel.mealTime) ?? .breakfast
        
        if let domainMealData = managedModel.mealData {
            self.mealData = domainMealData
                .compactMap { $0 as? DomainMealData }
                .compactMap { MealData(from: $0) }
        } else {
            self.mealData = []
        }
    }
}
