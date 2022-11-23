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
    func getSearchHistory() -> [String]
    func getFoodViewModel(_ model: Product) -> FoodCellView.FoodViewModel
    func getFoodViewModel(_ model: Dish) -> FoodCellView.FoodViewModel
    func didTapBackButton()
    func didTapCell(_ type: Food)
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
    
    private func getSubInfo(_ model: Dish, type: FoodInfoCases) -> Int? {
        switch type {
        case .carb:
            return Int(model.carbs)
        case .fat:
            return Int(model.fat)
        case .kcal:
            return Int(model.kсal)
        case .off:
            return nil
        case .protein:
            return Int(model.protein)
        }
    }
    
    private func getSubInfo(_ model: Product, type: FoodInfoCases) -> Int? {
        switch type {
        case .carb:
            return Int(model.carbs)
        case .fat:
            return Int(model.fat)
        case .kcal:
            return model.kcal
        case .off:
            return nil
        case .protein:
            return Int(model.protein)
        }
    }
}

extension AddFoodPresenter: AddFoodPresenterInterface {
    func setFoodType(_ type: AddFood) {
        self.foodType = type
    }
    
    func getSearchHistory() -> [String] {
        UDM.searchHistory
    }
    
    func getFoodViewModel(_ model: Dish) -> FoodCellView.FoodViewModel {
        FoodCellView.FoodViewModel(
            id: model.id,
            title: model.title,
            description: model.info ?? "",
            tag: model.tags.first?.tag ?? "",
            kcal: model.kсal,
            flag: false,
            image: nil,
            subInfo: getSubInfo(model, type: view.getFoodInfoType()),
            color: view.getFoodInfoType().getColor()
        )
    }
    
    func getFoodViewModel(_ model: Product) -> FoodCellView.FoodViewModel {
        FoodCellView.FoodViewModel(
            id: model.id,
            title: model.title,
            description: model.servings?
                .compactMap { $0.title }
                .joined(separator: ", ") ?? "",
            tag: model.brand ?? "",
            kcal: model.kcal,
            flag: false,
            image: nil,
            subInfo: getSubInfo(model, type: view.getFoodInfoType()),
            color: view.getFoodInfoType().getColor()
        )
    }
    
    func didTapBackButton() {
        router?.closeViewController()
    }
    
    func didTapCell(_ type: Food) {
        switch type {
        case .product(let product):
            router?.openProductViewController(product)
        case .dishes:
            return
        case .userProduct:
            return
        }
    }
}
