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
    func didTapBackButton()
    func didTapCell(_ type: Food)
    func search(_ request: String, complition: ((Bool) -> Void)?)
    func getSubInfo(_ food: Food?, _ type: FoodInfoCases) -> Double?
    func didTapCountControl(_ foods: [Food], complition: @escaping ([Food]) -> Void )
    func didTapScannerButton()
    func saveMeal(_ mealTime: MealTime, foods: [Food])
    func createFood(_ type: FoodCreate)
}

final class AddFoodPresenter {

    unowned var view: AddFoodViewControllerInterface
    let router: AddFoodRouterInterface?
    let interactor: AddFoodInteractorInterface?
    
    private var foods: [Food]? {
        didSet {
            view.setFoods(foods ?? [])
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
            let dishes = FDS.shared.getFrequentDishes(10)
            let products = FDS.shared.getFrequentProducts(10)
            
            self.foods = products.foods + dishes.foods
        case .recent:
            let dishes = FDS.shared.getRecentDishes(10)
            let products = FDS.shared.getRecentProducts(10)
            
            self.foods = products.foods + dishes.foods
        case .favorites:
            let dishes = FDS.shared.getFavoriteDishes()
            let products = FDS.shared.getFavoriteProducts()
            
            self.foods = products.foods + dishes.foods
        case .myMeals:
            self.foods = FDS.shared.getAllMeals().foods
        case .myRecipes:
            self.foods = []
        case .myFood:
            let product = DSF.shared.getAllStoredProducts().filter { $0.isUserProduct }
            self.foods = product.foods
        case .search:
            self.foods = []
        }
    }
    
    private func searchAmongFavorites(_ request: String) -> [Food] {
        let favoriteDishes = FDS.shared.getFavoriteDishes()
        let favoriteProducts = FDS.shared.getFavoriteProducts()
        
        let smartSearch: SmartSearch = .init(request)
        
        let filteredDishes = favoriteDishes.filter { smartSearch.matches($0.title) }
        let filteredProducts = favoriteProducts.filter {
            smartSearch.matches($0.title) || smartSearch.matches($0.brand ?? "")
        }
        
        return filteredDishes.foods + filteredProducts.foods
    }
    
    private func searchAmongRecent(_ request: String) -> [Food] {
        let recentDishes = FDS.shared.getRecentDishes(10)
        let recentProducts = FDS.shared.getRecentProducts(10)
        
        let smartSearch: SmartSearch = .init(request)
        
        let filteredDishes = recentDishes.filter { smartSearch.matches($0.title) }
        let filteredProducts = recentProducts.filter {
            smartSearch.matches($0.title) || smartSearch.matches($0.brand ?? "")
        }
        
        return filteredDishes.foods + filteredProducts.foods
    }
    
    private func searchAmongAll(_ request: String) -> [Food] {
        let dishes = DSF.shared.getAllStoredDishes()
        let products = DSF.shared.getAllStoredProducts()
        
        let smartSearch: SmartSearch = .init(request)
        
        let filteredDishes = dishes.filter { smartSearch.matches($0.title) }
        let filteredProducts = products.filter {
            smartSearch.matches($0.title) || smartSearch.matches($0.brand ?? "")
        }
        
        return filteredDishes.foods + filteredProducts.foods
    }
    
    private func searchAmongFrequent(_ request: String) -> [Food] {
        let frequentDishes = FDS.shared.getFrequentDishes(10)
        let frequentProducts = FDS.shared.getFrequentProducts(10)
        
        let smartSearch: SmartSearch = .init(request)
        
        let filteredDishes = frequentDishes.filter { smartSearch.matches($0.title) }
        let filteredProducts = frequentProducts.filter {
            smartSearch.matches($0.title) || smartSearch.matches($0.brand ?? "")
        }
        
        return filteredDishes.foods + filteredProducts.foods
    }
}

extension AddFoodPresenter: AddFoodPresenterInterface {
    func setFoodType(_ type: AddFood) {
        self.foodType = type
    }
    
    func getSearchHistory() -> [String] {
        UDM.searchHistory
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
        case .meal:
            return
        }
    }
    
    func didTapCountControl(_ foods: [Food], complition: @escaping ([Food]) -> Void ) {
        router?.openSelectedFoodCellsVC(foods, complition: { newFoods in
            complition(newFoods)
        })
    }
    
    func didTapScannerButton() {
        router?.openScanner()
    }
    
    func search(_ request: String, complition: ((Bool) -> Void)?) {
        let frequents = searchAmongFrequent(request)
        let favorites = searchAmongFavorites(request)
        let recents = searchAmongRecent(request)
        let basicFood = searchAmongAll(request)
        let foods = frequents + recents + favorites + basicFood
        
        self.foods = foods
        
        complition?(!foods.isEmpty)
    }
    
    func getSubInfo(_ food: Food?, _ type: FoodInfoCases) -> Double? {
        return food?.foodInfo[type]
    }
    
    func saveMeal(_ mealTime: MealTime, foods: [Food]) {
        FDS.shared.createMeal(
            mealTime: mealTime,
            dishes: foods.dishes,
            products: foods.products
        )
    }
    
    func createFood(_ type: FoodCreate) {
        switch type {
        case .food:
            router?.openCreateProduct()
        case .recipe:
            return
        case .meal:
            return
        }
    }
}
