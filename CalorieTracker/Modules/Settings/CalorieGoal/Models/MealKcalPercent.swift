//
//  MealKcalPercent.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import Foundation

struct MealKcalPercent: Codable {
    let breakfast: Double
    let lunch: Double
    let dinner: Double
    let snacks: Double
}

extension MealKcalPercent {
    static let standart: MealKcalPercent = .init(breakfast: 0.25, lunch: 0.35, dinner: 0.30, snacks: 0.10)
}

extension MealKcalPercent: Equatable {}
