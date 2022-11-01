//
//  FoodData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.11.2022.
//

import Foundation

typealias FoodDataResult = (Result<[FoodData], ErrorDomain>) -> Void

struct FoodData {
    let id: Int
    let dateLastUse: Date
    let favorites: Bool
    let numberUses: Int
    let food: Food?
    
    init?(from managedModel: DomainFoodData) {
        id = Int(managedModel.id)
        dateLastUse = managedModel.dateLastUse
        favorites = managedModel.favorites
        numberUses = Int(managedModel.numberUses)
        
        if let domainDish = managedModel.dish, let dish = Dish(from: domainDish) {
            food = .dishes(dish)
        } else if let domainProduct = managedModel.product, let product = Product(from: domainProduct) {
            food = .product(product)
        } else {
            food = nil
        }
    }
    
    init(id: Int, dateLastUse: Date, favorites: Bool, numberUses: Int) {
        self.id = id
        self.dateLastUse = dateLastUse
        self.favorites = favorites
        self.numberUses = numberUses
        self.food = nil
    }
}

extension FoodData {
    func setChild<T>(_ child: T) {
        switch child.self {
        case is Product:
            guard let child = child as? Product else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, productID: child.id)
        case is Dish:
            guard let child = child as? Dish else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, dishID: child.id)
        default:
            return
        }
    }
}
