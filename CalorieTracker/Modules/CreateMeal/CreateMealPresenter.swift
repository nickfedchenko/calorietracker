//
//  CreateMealPresenter.swift
//  CIViperGenerator
//
//  Created by Alexandru Jdanov on 27.02.2023.
//  Copyright © 2023 Alexandru Jdanov. All rights reserved.
//

import Foundation

protocol CreateMealPresenterInterface: AnyObject {
    func didTapAddFood(with searchRequest: String)
    func addProduct(_ product: Product)
}

class CreateMealPresenter {

    unowned var view: CreateMealViewControllerInterface
    let router: CreateMealRouterInterface?
    let interactor: CreateMealInteractorInterface?
    
    var products: [Product]? {
        didSet {
            view.setProducts(products ?? [])
        }
    }

    init(
        interactor: CreateMealInteractorInterface,
        router: CreateMealRouterInterface,
        view: CreateMealViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.products = []
    }
}

extension CreateMealPresenter: CreateMealPresenterInterface {
    func didTapAddFood(with searchRequest: String) {
        router?.openAddFoodVC(with: searchRequest)
    }
    
    func addProduct(_ product: Product) {
        products?.append(product)
    }
}
