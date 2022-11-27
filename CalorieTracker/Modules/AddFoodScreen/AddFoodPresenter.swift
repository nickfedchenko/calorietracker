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
    func search(_ request: String)
    func getSubInfo(_ food: Food?, _ type: FoodInfoCases) -> Int?
    func didTapSelectedButton(_ foods: [Food])
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
            break
        case .myFood:
            break
        case .search:
            self.foods = []
        }
    }
    
    private func searchAmongFavorites(_ request: String) -> [Food] {
        let lowRequest = request.lowercased()
        let favoriteDishes = FDS.shared.getFavoriteDishes()
        let favoriteProducts = FDS.shared.getFavoriteProducts()
        
        let filteredDishes = favoriteDishes.filter { $0.title.lowercased().contains(lowRequest) }
        let filteredProducts = favoriteProducts.filter {
            $0.title.lowercased().contains(lowRequest)
            || $0.brand?.lowercased().contains(lowRequest) ?? false
        }
        
        return filteredDishes.foods + filteredProducts.foods
    }
    
    private func searchAmongRecent(_ request: String) -> [Food] {
        let lowRequest = request.lowercased()
        let recentDishes = FDS.shared.getRecentDishes(10)
        let recentProducts = FDS.shared.getRecentProducts(10)
        
        let filteredDishes = recentDishes.filter { $0.title.lowercased().contains(lowRequest) }
        let filteredProducts = recentProducts.filter {
            $0.title.lowercased().contains(lowRequest)
            || $0.brand?.lowercased().contains(lowRequest) ?? false
        }
        
        return filteredDishes.foods + filteredProducts.foods
    }
    
    private func searchAmongFrequent(_ request: String) -> [Food] {
        let lowRequest = request.lowercased()
        let frequentDishes = FDS.shared.getFrequentDishes(10)
        let frequentProducts = FDS.shared.getFrequentProducts(10)
        
        let filteredDishes = frequentDishes.filter { $0.title.lowercased().contains(lowRequest) }
        let filteredProducts = frequentProducts.filter {
            $0.title.lowercased().contains(lowRequest)
            || $0.brand?.lowercased().contains(lowRequest) ?? false
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
        case .userProduct:
            return
        case .meal:
            return
        }
    }
    
    func didTapSelectedButton(_ foods: [Food]) {
        router?.openSelectedFoodCellsVC(foods)
    }
    
    func search(_ request: String) {
        let frequents = searchAmongFrequent(request)
        let favorites = searchAmongFavorites(request)
        let recents = searchAmongRecent(request)
        let basicDishes = DSF.shared.searchDishes(by: request).foods
        let basicProducts = DSF.shared.searchProducts(by: request).foods
        
        self.foods = frequents + recents + favorites + basicDishes + basicProducts
    }
    
    func getSubInfo(_ food: Food?, _ type: FoodInfoCases) -> Int? {
        return food?.foodInfo[type]
    }
}
