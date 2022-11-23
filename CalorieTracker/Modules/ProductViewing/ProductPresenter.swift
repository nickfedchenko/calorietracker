//
//  ProductPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProductPresenterInterface: AnyObject {
    func getDailyFoodIntake() -> DailyFoodIntake
    func didTapCloseButton()
    func getProduct() -> Product
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
    func getDailyFoodIntake() -> DailyFoodIntake {
        return .init(fat: 100, protein: 100, kcal: 100, carb: 100)
    }
    
    func didTapCloseButton() {
        router?.closeViewController()
    }
    
    func getProduct() -> Product {
        return self.product
    }
}
