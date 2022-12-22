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
    func getProduct() -> Product
    func saveNutritionDaily(_ value: DailyNutrition)
}

class ProductPresenter {
    
    unowned var view: ProductViewControllerInterface
    let router: ProductRouterInterface?
    let interactor: ProductInteractorInterface?
    let product: Product
    
    init(
        interactor: ProductInteractorInterface,
        router: ProductRouterInterface,
        view: ProductViewControllerInterface,
        product: Product
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.product = product
    }
}

extension ProductPresenter: ProductPresenterInterface {
    func getNutritionDaily() -> DailyNutrition? {
        return FDS.shared.getNutritionToday().nutrition
    }
    
    func getNutritionDailyGoal() -> DailyNutrition? {
        FDS.shared.getNutritionGoals()
    }
    
    func didTapCloseButton() {
        switch view.getOpenController() {
        case .addFood:
            router?.closeViewController(true)
        case .createProduct:
            router?.closeViewController(false)
            view.viewControllerShouldClose()
        }
    }
    
    func getProduct() -> Product {
        return self.product
    }
    
    func saveNutritionDaily(_ value: DailyNutrition) {
        FDS.shared.addNutrition(day: Date().day, nutrition: value)
    }
}
