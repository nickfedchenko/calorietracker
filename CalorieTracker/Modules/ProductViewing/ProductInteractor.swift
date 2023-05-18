//
//  ProductInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProductInteractorInterface: AnyObject {
    func updateFoodData(_ flag: Bool?, with food: Food)
    func getProduct() -> Product?
    func getMealTime() -> MealTime?
}

class ProductInteractor {
    weak var presenter: ProductPresenterInterface?
    var product: Product?
    var mealTime: MealTime?
    var onAddToNewMeal: ((Product) -> Void)?
}

extension ProductInteractor: ProductInteractorInterface {
    func getProduct() -> Product? {
        return product
    }
    
    func getMealTime() -> MealTime? {
        return mealTime
    }
    
    func updateFoodData(_ flag: Bool?, with food: Food) {
        guard let product = product else {
            return
        }
        
        FDS.shared.foodUpdateNew(
            food: food,
            favorites: flag
        )
    }
}
