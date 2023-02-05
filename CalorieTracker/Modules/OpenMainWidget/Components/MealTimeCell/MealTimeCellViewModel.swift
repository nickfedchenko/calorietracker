//
//  MealTimeCellViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.02.2023.
//

import UIKit

struct MealTimeCellViewModel {
    let foods: [Food]
    let mealtime: MealTime
    
    var kcal: Int { return calculateNutrient(.kcal) }
    var carbs: Int { return calculateNutrient(.carb) }
    var protein: Int { return calculateNutrient(.protein) }
    var fats: Int { return calculateNutrient(.fat) }
    
    private func calculateNutrient(_ type: FoodInfoCases) -> Int {
        foods
            .compactMap { $0.foodInfo[type] }
            .compactMap { Int($0) }
            .sum()
    }
}