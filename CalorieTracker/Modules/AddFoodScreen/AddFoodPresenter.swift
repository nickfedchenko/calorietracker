//
//  AddFoodPresenter.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol AddFoodPresenterInterface: AnyObject {
    func setFoodType(_ type: AddFood)
}

final class AddFoodPresenter {

    unowned var view: AddFoodViewControllerInterface
    let router: AddFoodRouterInterface?
    let interactor: AddFoodInteractorInterface?
    
    private var dishes: [Dish]? {
        didSet {
            view.setDishes(dishes ?? [])
        }
    }
    
    private var products: [Product]? {
        didSet {
            view.setProducts(products ?? [])
        }
    }
    
    private var meals: [Meal]? {
        didSet {
            view.setMeals(meals ?? [])
        }
    }
    
    private var foodType: AddFood? {
        didSet {
            configureView()
        }
    }

    init(
        interactor: AddFoodInteractorInterface,
        router: AddFoodRouterInterface,
        view: AddFoodViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func configureView() {
        guard let foodType = foodType else { return }
        
        switch foodType {
        case .frequent:
            self.dishes = FDS.shared.getFrequentDishes(10)
            self.products = FDS.shared.getFrequentProducts(10)
        case .recent:
            self.dishes = FDS.shared.getRecentDishes(10)
            self.products = FDS.shared.getRecentProducts(10)
        case .favorites:
            self.dishes = FDS.shared.getFavoriteDishes()
            self.products = FDS.shared.getFavoriteProducts()
        case .myMeals:
            self.meals = FDS.shared.getAllMeals()
        case .myRecipes:
            break
        case .myFood:
            break
        }
    }
}

extension AddFoodPresenter: AddFoodPresenterInterface {
    func setFoodType(_ type: AddFood) {
        self.foodType = type
    }
}
