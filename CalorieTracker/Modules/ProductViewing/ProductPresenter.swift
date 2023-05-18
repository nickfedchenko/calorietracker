//
//  ProductPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProductPresenterInterface: AnyObject {
    func getNutritionDailyGoal() -> DailyNutrition?
    func getNutritionDaily() -> DailyNutrition?
    func didTapCloseButton()
    func getProduct() -> Product?
    func saveNutritionDaily(_ weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?)
    func didTapAddToNewMeal(_ weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?)
    func didTapToFavorites(isFavorite: Bool, weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?)
    var isFavoritesProduct: Bool? { get }
}

class ProductPresenter {
    
    unowned var view: ProductViewControllerInterface
    let router: ProductRouterInterface?
    let interactor: ProductInteractorInterface?
    
    init(
        interactor: ProductInteractorInterface,
        router: ProductRouterInterface,
        view: ProductViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ProductPresenter: ProductPresenterInterface {
 
    func didTapToFavorites(isFavorite: Bool, weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?) {
        guard let product = getProduct() else { return }
        if let unit = unit, let unitCount = unitCount {
            let unitData: FoodUnitData = (unit, unitCount)
            interactor?.updateFoodData(isFavorite, with: .product(product, customAmount: weight, unit: unitData))
        } else {
            interactor?.updateFoodData(isFavorite, with: .product(product, customAmount: weight, unit: nil))
        }
    }
    
    var isFavoritesProduct: Bool? {
        guard let product = interactor?.getProduct() else { return nil }
        return FDS.shared.getFoodData(.product(product, customAmount: nil, unit: nil))?.favorites
    }
    
    func getNutritionDaily() -> DailyNutrition? {
        return FDS.shared.getNutritionToday().nutrition
    }
    
    func getNutritionDailyGoal() -> DailyNutrition? {
        FDS.shared.getNutritionGoals()
    }
    
    func didTapCloseButton() {
        switch view.getOpenController() {
        case .addFood:
            router?.closeViewController(true, completion: nil)
        case .createProduct:
            router?.closeViewController(false, completion: nil)
            view.viewControllerShouldClose()
        case .createMeal:
            router?.closeViewController(false, completion: nil)
        }
    }
    
    func getProduct() -> Product? {
        return interactor?.getProduct()
    }
    
    func saveNutritionDaily(_ weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?) {
        guard var product = interactor?.getProduct() else { return }
        if let unit = unit, let unitCount = unitCount {
            let unitData: FoodUnitData = (unit, unitCount)
            product.foodDataId = FDS
                .shared.foodUpdateNew(food: .product(product, customAmount: weight, unit: unitData), favorites: nil)
        } else {
            product.foodDataId = FDS
                .shared.foodUpdateNew(food: .product(product, customAmount: weight, unit: nil), favorites: nil)
        }
      
//        FDS.shared.saveProduct(product: product)
        router?.closeViewController(true) { [weak self] in
            if let unit = unit, let unitCount = unitCount {
                self?.router?.addToDiary(.product(product, customAmount: weight, unit: (unit, unitCount)))
            } else {
                self?.router?.addToDiary(.product(product, customAmount: nil, unit: nil))
            }
            LoggingService.postEvent(event: .diaryaddfromfoodscreen)
            self?.view.viewControllerShouldClose()
        }
    }
    
    func didTapAddToNewMeal(_ weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?) {
        guard let product = interactor?.getProduct() else { return }
        if let unit = unit, let unitCount = unitCount {
            router?.dismissToCreateMeal(with: .product(product, customAmount: weight, unit: (unit, unitCount)))
        } else {
            router?.dismissToCreateMeal(with: .product(product, customAmount: nil, unit: nil))
        }
    }
}
