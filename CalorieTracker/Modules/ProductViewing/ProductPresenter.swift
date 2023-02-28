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
    func createFoodData()
    func didTapFavoriteButton(_ flag: Bool)
    
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
    
    var isFavoritesProduct: Bool? {
        guard let product = interactor?.getProduct() else { return nil }
        return FDS.shared.getFoodData(.product(product, customAmount: nil, unit: nil))?.favorites
    }
    
    func didTapFavoriteButton(_ flag: Bool) {
        interactor?.updateFoodData(flag)
    }
    
    func createFoodData() {
        if interactor?.getProduct()?.foodDataId == nil {
            interactor?.updateFoodData(nil)
        }
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
        }
    }
    
    func getProduct() -> Product? {
        return interactor?.getProduct()
    }
    
    func saveNutritionDaily(_ weight: Double, unit: UnitElement.ConvenientUnit?, unitCount: Double?) {
        guard let product = interactor?.getProduct() else { return }
        router?.closeViewController(true) { [weak self] in
            if let unit = unit, let unitCount = unitCount {
                self?.router?.addToDiary(.product(product, customAmount: weight, unit: (unit, unitCount)))
            } else {
                self?.router?.addToDiary(.product(product, customAmount: nil, unit: nil))
            }
        }
    }
}
