//
//  DailyNutritionData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.12.2022.
//

import CoreData
import Foundation

struct DailyNutritionData {
    let day: Day
    let nutrition: DailyNutrition
    
    init(day: Day, nutrition: DailyNutrition) {
        self.day = day
        self.nutrition = nutrition
    }
    
    init?(from managedModel: DomainNutrition) {
        self.nutrition = .init(
            kcal: managedModel.kcal,
            carbs: managedModel.carbs,
            protein: managedModel.protein,
            fat: managedModel.fat
        )
        self.day = .init(
            day: Int(managedModel.day),
            month: Int(managedModel.month),
            year: Int(managedModel.year)
        )
    }
}
