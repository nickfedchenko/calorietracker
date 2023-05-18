//
//  CustomEntry.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 20.02.2023.
//

import Foundation

struct CustomEntry {
    let id: String
    let title: String
    let nutrients: CustomEntryNutrients
    let mealTime: MealTime
    
    var foodDataId: String?
    
    init?(from managedModel: DomainCustomEntry) {
        self.id = managedModel.id
        self.title = managedModel.title
        self.nutrients = CustomEntryNutrients(
            kcal: managedModel.kcal,
            carbs: managedModel.carbs,
            proteins: managedModel.proteins,
            fats: managedModel.fats
        )
        
        self.mealTime = MealTime(
            rawValue: managedModel.mealTime
        ) ?? .breakfast
        
        self.foodDataId = managedModel.foodData?.id
    }
    
    init(title: String,
         nutrients: CustomEntryNutrients,
         mealTime: MealTime) {
        self.id = UUID().uuidString
        self.title = title
        self.nutrients = nutrients
        self.mealTime = mealTime
    }
}

extension CustomEntry: Equatable {
    static func == (lhs: CustomEntry, rhs: CustomEntry) -> Bool {
        return lhs.id == rhs.id && lhs.foodDataId == rhs.foodDataId
    }
}

struct CustomEntryNutrients: Codable {
    let kcal: Double
    let carbs: Double
    let proteins: Double
    let fats: Double
}
