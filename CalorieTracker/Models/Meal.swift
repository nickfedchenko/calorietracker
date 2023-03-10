//
//  Meal.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.11.2022.
//

import Foundation

struct Meal {
    let id: String
    let title: String
    let mealTime: MealTime
    let products: [Product]
    let dishes: [Dish]
    let customEntries: [CustomEntry]
    let photoURL: String

    var foodDataId: String?
    
    init?(from managedModel: DomainMeal) {
        self.id = managedModel.id
        self.title = managedModel.title
        self.photoURL = managedModel.photoURL
        self.mealTime = MealTime(rawValue: managedModel.mealTime) ?? .breakfast
        self.products = managedModel.products?
            .compactMap { $0 as? DomainProduct }
            .compactMap { Product(from: $0) } ?? []
        self.dishes = managedModel.dishes?
            .compactMap { $0 as? DomainDish }
            .compactMap { Dish(from: $0) } ?? []
        self.customEntries = managedModel.customEntries?
            .compactMap { $0 as? DomainCustomEntry }
            .compactMap { CustomEntry(from: $0) } ?? []
        
        self.foodDataId = managedModel.foodData?.id
        
    }
    
    struct Photo: Codable {
        var photoData: Data?
    }
    
    init(mealTime: MealTime, title: String, photoURL: String?) {
        self.mealTime = mealTime
        self.title = title
        self.photoURL = photoURL ?? ""
        self.products = []
        self.dishes = []
        self.customEntries = []
        self.id = UUID().uuidString
    }
}

struct MealNutrients: Codable {
    let kcal: Double
    let carbs: Double
    let proteins: Double
    let fats: Double
}

enum MealTime: String {
    case breakfast
    case launch
    case dinner
    case snack
}

extension Meal {
    func setChild(dishes: [Dish], products: [Product], customEntries: [CustomEntry]) {
        DSF.shared.setChildMeal(
            mealId: self.id,
            dishesID: dishes.map { $0.id },
            productsID: products.map { $0.id },
            customEntriesID: customEntries.map { $0.id }
        )
    }
}

extension Meal: Equatable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Meal {
    var nutrients: MealNutrients {
        let totalKcal = products.reduce(0.0, { $0 + $1.kcal }) +
        dishes.reduce(0.0, { $0 + $1.kcal }) +
        customEntries.reduce(0.0, { $0 + $1.nutrients.kcal })
        
        let totalCarbs = products.reduce(0.0, { $0 + $1.carbs }) +
        dishes.reduce(0.0, { $0 + $1.carbs }) +
        customEntries.reduce(0.0, { $0 + $1.nutrients.carbs })
        
        let totalProteins = products.reduce(0.0, { $0 + $1.protein }) +
        dishes.reduce(0.0, { $0 + $1.protein }) +
        customEntries.reduce(0.0, { $0 + $1.nutrients.proteins })
        
        let totalFats = products.reduce(0.0, { $0 + $1.fat }) +
        dishes.reduce(0.0, { $0 + $1.fat }) +
        customEntries.reduce(0.0, { $0 + $1.nutrients.fats })
        
        return MealNutrients(kcal: totalKcal, carbs: totalCarbs, proteins: totalProteins, fats: totalFats)
    }
}
