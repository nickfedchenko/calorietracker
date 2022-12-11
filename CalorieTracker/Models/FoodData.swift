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
            food = .dishes(dish)
        } else if let domainProduct = managedModel.product, let product = ProductDTO(from: domainProduct) {
            food = .product(product)
        } else if let domainUserProduct = managedModel.userProduct,
                    let userProduct = UserProduct(from: domainUserProduct) {
            food = .userProduct(userProduct)
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
        case is ProductDTO:
            guard let child = child as? ProductDTO else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, productID: child.id)
        case is Dish:
            guard let child = child as? Dish else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, dishID: child.id)
        case is UserProduct:
            guard let child = child as? UserProduct else { return }
            DSF.shared.setChildFoodData(foodDataId: self.id, userProductID: child.id)
        default:
            return
        }
    }
}
