//
//  NutrientMeasurment.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import Foundation

struct NutrientMeasurment {
    private static let kcalPerGramOfProtein: Double = 4
    private static let kcalPerGramOfFat: Double = 9
    private static let kcalPerGramOfCarb: Double = 4
    
    static func convert(
        value: Double,
        type: NutrientType,
        from: NutrientUnit,
        to: NutrientUnit
    ) -> Double {
        var kcalPerGram: Double
        
        switch type {
        case .fat:
            kcalPerGram = kcalPerGramOfFat
        case .protein:
            kcalPerGram = kcalPerGramOfProtein
        case .carbs:
            kcalPerGram = kcalPerGramOfCarb
        }
        
        switch (from, to) {
        case (.gram, .kcal):
            return value * kcalPerGram
        case (.kcal, .gram):
            return value / kcalPerGram
        default:
            return value
        }
    }
    
    static func convertNutrition(nutrition: DailyNutrition, from: NutrientUnit, to: NutrientUnit) -> DailyNutrition {
        let protein: Double = convert(value: nutrition.protein, type: .protein, from: from, to: to)
        let fat: Double = convert(value: nutrition.fat, type: .fat, from: from, to: to)
        let carbs: Double = convert(value: nutrition.carbs, type: .carbs, from: from, to: to)
        return .init(kcal: nutrition.kcal, carbs: carbs, protein: protein, fat: fat)
    }
}
