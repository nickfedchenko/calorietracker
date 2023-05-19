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
    let foods: [Food]
    let photoURL: String
    var tempDateLastUse: Date?
    var tempNumberOfUses: Int?
    
    var foodDataId: String?
    
    init?(from managedModel: DomainMeal) {
        self.id = managedModel.id ?? ""
        self.title = managedModel.title ?? ""
        self.mealTime = MealTime(rawValue: managedModel.mealTime ?? "") ?? .breakfast
        self.photoURL = managedModel.photoURL ?? ""
        if let components = managedModel.components?.array as? [DomainMealComponent] {
            var foods: [Food] = []
            for component in components {
                if let dish = component.dish {
                    foods.append(.dishes(dish, customAmount: component.dishAmount))
                }
                
                if let product = component.product {
                    var unitId = component.productUnitID
                    var shouldAddUnit = unitId > 0
                    if shouldAddUnit {
                        let unit = product.units?.first(where: { $0.id == Int(component.productUnitID) })?.convenientUnit
                        let food: Food = .product(
                            product,
                            customAmount: nil,
                            unit: FoodUnitData(
                                unit: unit ?? .gram(
                                    title: R.string.localizable.gram(),
                                    shortTitle: R.string.localizable.measurementG(),
                                    coefficient: 1
                                ),
                                count: component.productAmount
                            )
                        )
                        foods.append(food)
                        continue
                    } else {
                        if component.productAmount > 0 {
                            foods.append(.product(product, customAmount: component.productAmount, unit: nil))
                            continue
                        } else {
                            foods.append(.product(product, customAmount: nil, unit: nil))
                            continue
                        }
                    }
                }
                
                if let entry = component.customEntry {
                    foods.append(.customEntry(entry))
                }
            }
            self.foods = foods
        } else {
            self.foods = []
        }
    }
    
    struct Photo: Codable {
        var photoData: Data?
    }
    
    init(mealTime: MealTime, title: String, photoURL: String?, foods: [Food]) {
        self.mealTime = mealTime
        self.title = title
        self.photoURL = photoURL ?? ""
        self.foods = foods
        self.id = UUID().uuidString
    }
    
    init(id: String, mealTime: MealTime, title: String, photoURL: String?, foods: [Food]) {
        self.mealTime = mealTime
        self.title = title
        self.photoURL = photoURL ?? ""
        self.foods = foods
        self.id = id
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
    case lunch
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
        return lhs.id == rhs.id && lhs.foodDataId == rhs.foodDataId
    }
}

extension Meal {
    var nutrients: MealNutrients {
        let totalKcal = foods.reduce(Double(0)) { partialResult, food in
            partialResult + (food.foodInfo[.kcal] ?? 0)
        }
        
        let totalCarbs = foods.reduce(Double(0)) { partialResult, food in
            partialResult + (food.foodInfo[.carb] ?? 0)
        }
        
        let totalProteins = foods.reduce(Double(0)) { partialResult, food in
            partialResult + (food.foodInfo[.protein] ?? 0)
        }
        
        let totalFats = foods.reduce(Double(0)) { partialResult, food in
            partialResult + (food.foodInfo[.fat] ?? 0)
        }
        return MealNutrients(kcal: totalKcal, carbs: totalCarbs, proteins: totalProteins, fats: totalFats)
    }
}
