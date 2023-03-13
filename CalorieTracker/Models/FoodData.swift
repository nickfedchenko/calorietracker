//
//  FoodData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.11.2022.
//

import Foundation

typealias FoodDataResult = (Result<[FoodData], ErrorDomain>) -> Void

struct FoodData {
    let id: String
    let dateLastUse: Date
    let favorites: Bool
    let numberUses: Int
    let food: Food?
    
    init?(from managedModel: DomainFoodData) {
        id = managedModel.id
        dateLastUse = managedModel.dateLastUse
        favorites = managedModel.favorites
        numberUses = Int(managedModel.numberUses)
        
        if let domainDish = managedModel.dish, let dish = Dish(from: domainDish) {
            food = .dishes(dish, customAmount: nil)
        } else if let domainProduct = managedModel.product, let product = Product(from: domainProduct) {
            food = .product(product, customAmount: nil, unit: nil)
        } else if let domainCustomEntry = managedModel.customEntry,
                  let customEntry = CustomEntry(from: domainCustomEntry) {
            food = .customEntry(customEntry)
        } else if let domainMeal = managedModel.meal,
                  let meal = Meal(from: domainMeal) {
            food = .meal(meal)
        } else {
            food = nil
        }
    }
    
    init(dateLastUse: Date, favorites: Bool, numberUses: Int) {
        self.id = UUID().uuidString
        self.dateLastUse = dateLastUse
        self.favorites = favorites
        self.numberUses = numberUses
        self.food = nil
    }
}

extension FoodData {
    func setChild<T>(_ child: T) {
        switch child.self {
        case is Dish:
            guard let child = child as? Dish else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, dishID: child.id)
        case is Product:
            guard let child = child as? Product else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, productID: child.id)
        case is CustomEntry:
            guard let child = child as? CustomEntry else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, customEntryID: child.id)
        case is Meal:
            guard let child = child as? Meal else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, customEntryID: child.id)
        default:
            return
        }
    }
}
