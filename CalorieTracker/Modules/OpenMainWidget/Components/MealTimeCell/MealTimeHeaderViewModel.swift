//
//  MealTimeHeaderViewModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.02.2023.
//

import Foundation

struct MealTimeHeaderViewModel {
    let mealTime: MealTime
    let burnKcal: Int
    let carbs: Int
    let protein: Int
    let fat: Int
    let shouldShowChevrons: Bool
}
