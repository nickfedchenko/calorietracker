//
//  DailyNutrition .swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.11.2022.
//

import Foundation

struct DailyNutrition: Codable, AdditiveArithmetic {
    static var zero: DailyNutrition = .init(.zero)
    
    let kcal: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    
    init(kcal: Double, carbs: Double, protein: Double, fat: Double) {
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fat = fat
    }
    
    private init(_ value: Double) {
        self.kcal = value
        self.carbs = value
        self.protein = value
        self.fat = value
    }
    
    static func + (lhs: DailyNutrition, rhs: DailyNutrition) -> DailyNutrition {
        .init(
            kcal: lhs.kcal + rhs.kcal,
            carbs: lhs.carbs + rhs.carbs,
            protein: lhs.protein + rhs.protein,
            fat: lhs.fat + rhs.fat
        )
    }
    
    static func - (lhs: DailyNutrition, rhs: DailyNutrition) -> DailyNutrition {
        .init(
            kcal: lhs.kcal - rhs.kcal,
            carbs: lhs.carbs - rhs.carbs,
            protein: lhs.protein - rhs.protein,
            fat: lhs.fat - rhs.fat
        )
    }
}
