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
    func didTapBackButton(shouldShowReview: Bool)
    func didTapCell(_ type: Food)
    func search(_ request: String, complition: ((Bool) -> Void)?)
    func getSubInfo(_ food: Food?, _ type: FoodInfoCases) -> Int?
    func didTapCountControl(_ foods: [Food], complition: @escaping ([Food]) -> Void )
    func didTapScannerButton()
    func saveMeal(_ mealTime: MealTime, foods: [Food])
    func createFood()
    func createFood(_ type: FoodCreate)
    func getMealTime() -> MealTime?
    func scannerDidRecognized(barcode: String)
    func updateSelectedFoodFromSearch(food: Food)
    func updateSelectedFoodFromCustomEntry(food: Food)
    func didTapCalorieButton(mealTime: MealTime)
    func stopSearchQuery()
    func updateCustomFood(food: Food)
    func didTapCloseButton()
    func getAllMeals() -> [Meal]
    func openEditMeal(meal: Meal)
    func realoadCollectionView()
    func dismissToCreateMeal(with food: Food)
}

final class AddFoodPresenter {

    unowned var view: AddFoodViewControllerInterface
    let router: AddFoodRouterInterface?
    let interactor: AddFoodInteractorInterface?

    let searchQueue: OperationQueue =  {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    private let searchGroup = DispatchGroup()
    private var createFoodType: FoodCreate?
    
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
        let now = Date().timeIntervalSince1970
        guard let foodType = foodType else {
            return
        }
        
        switch foodType {
        case .frequent:
            let dishes = FDS.shared.getFrequentDishes(10)
            var products = FDS.shared.getFrequentProducts(10)
            let customEntries = FDS.shared.getFrequentCustomEntries(10)
            self.foods = products.foods + dishes.foods + customEntries.foods
        case .recent:
            let dishes = FDS.shared.getRecentDishes(10)
            let products = FDS.shared.getRecentProducts(10)
            let customEntries = FDS.shared.getRecentCustomEntries(10)
            self.foods = products + dishes.foods + customEntries.foods
        case .favorites:
            let dishes = FDS.shared.getFavoriteDishes()
            let products = FDS.shared.getFavoriteProducts()
            self.foods = products.foods + dishes.foods
        case .myMeals:
            self.foods = getAllMeals().foods
        case .myRecipes:
            self.foods = []
        case .myFood:
            let products = DSF.shared.getMyProducts()
            self.foods = products.foods
        case .search:
            return
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
//        let recentDishes = FDS.shared.getRecentDishes(10)
//        let recentProducts = FDS.shared.getRecentProducts(10)
//
//        let smartSearch: SmartSearch = .init(request)
//
//        let filteredDishes = recentDishes.filter { smartSearch.matches($0.title) }
//        let filteredProducts = recentProducts.filter {
//            smartSearch.matches($0.title) || smartSearch.matches($0.brand ?? "")
//        }
//
        return  []// filteredProducts.foods + filteredDishes.foods
    }
    
    private func searchAmongAll(_ request: String) -> [Food] {
        var dishes = [Dish]()
        var products = [Product]()
        let semaphore = DispatchSemaphore(value: 0)
        DSF.shared.searchDishes(by: request) { dishesFound in
            dishes = dishesFound
            semaphore.signal()
        }
        
        DSF.shared.searchProducts(by: request) { productsFound in
            products = productsFound
            semaphore.signal()
        }
        semaphore.wait()
        semaphore.wait()
        let genericProducts = products.filter { $0.brand == nil && !$0.isUserProduct }
        let brandProducts = products.filter { $0.brand != nil && !$0.isUserProduct }
        let userProducts = products.filter { $0.isUserProduct }
        return genericProducts.foods + userProducts.foods + dishes.foods + brandProducts.foods
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
    
    private func search(byBarcode: String) -> [Food] {
        var products = [Product]()
        let semaphore = DispatchSemaphore(value: 0)
        DSF.shared.searchProducts(barcode: byBarcode) { productsFound in
            products = productsFound
            semaphore.signal()
        }
        semaphore.wait()
        return products.foods
    }
}

extension AddFoodPresenter: AddFoodPresenterInterface {

    func scannerDidRecognized(barcode: String) {
//        searchQueue.cancelAllOperations()
//        let operation = BlockOperation { [weak self] in
        var foundFood = search(byBarcode: barcode)
        
        DSF.shared.searchRemoteProduct(byBarcode: barcode) { products in
            DispatchQueue.main.async {
                self.foods = foundFood + products.filter { $0.kcal > 0 }.foods
                self.view.updateState(for: .search((foundFood + products.foods).isEmpty ? .noResults : .foundResults))
                if (self.foods?.count ?? 0) > 0 {
                    LoggingService.postEvent(event: .diaryscanfound(succeeded: !foundFood.isEmpty))
                    RateRequestManager.increment(for: .scanner)
                }
            }
        }
            DispatchQueue.main.async {
                self.foods = foundFood
                self.view.updateState(for: .search(foundFood.isEmpty ? .noResults : .foundResults))
                self.view.setSearchField(to: barcode)
            }
    }
    
    func setFoodType(_ type: AddFood) {
        self.foodType = type
    }
    
    func getSearchHistory() -> [String] {
        UDM.searchHistory
    }
    
    func didTapBackButton(shouldShowReview: Bool = false) {
        router?.closeViewController(shouldAskForReview: shouldShowReview)
    }
    
    func didTapCell(_ type: Food) {
        switch type {
        case .product(let product, _, _):
            router?.openProductViewController(product)
        case .dishes(let dish, _):
            router?.openDishViewController(dish)
        case .meal:
            return
        case .customEntry:
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
    
    func didTapCalorieButton(mealTime: MealTime) {
        router?.openCustomEntryViewController(mealTime: mealTime)
    }
    
    func search(_ request: String, complition: ((Bool) -> Void)?) {
        //            let frequents = self.searchAmongFrequent(request)
        //            let favorites = self.searchAmongFavorites(request)
        //            let recents = self.searchAmongRecent(request)
        searchQueue.cancelAllOperations()
        print("Currently searching \(searchQueue.operationCount)")
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            guard !operation.isCancelled else {
                return
            }
            let current = Date().timeIntervalSince1970
            guard let self = self else { return }
            guard !operation.isCancelled else {
                return
            }
            let basicFood = self.searchAmongAll(request)
            guard !operation.isCancelled else {
                return
            }
            let searchByBarcode = self.search(byBarcode: request)
            guard !operation.isCancelled else {
                return
            }
            let foods = basicFood + searchByBarcode
            let done = Date().timeIntervalSince1970 - current
            DispatchQueue.main.async {
                guard !operation.isCancelled else {
                    return
                }
                self.foods = foods
                complition?(!foods.isEmpty)
            }
            
            DSF.shared.searchRemoteProduct(by: request) { [operation] products in
                guard !operation.isCancelled else {
                    print("cancelled with phrase \(request)")
                    return
                }
                DispatchQueue.main.async {
                    //                guard !operation.isCancelled else {
                    //                    return
                    //                }
                    print("Added to foods with phrase \(request)")
                    self.foods = foods + products.filter { $0.kcal > 0 }.foods
                    complition?(!foods.isEmpty)
                }
            }
        }
        operation.queuePriority = .high
        searchQueue.addOperation(operation)
    }
    
    func getSubInfo(_ food: Food?, _ type: FoodInfoCases) -> Int? {
        guard let info = food?.foodInfo[type] else { return nil }
        return Int(info)
    }
    
    func saveMeal(_ mealTime: MealTime, foods: [Food]) {
        foods.forEach {
            if case .customEntry(let customEntry) = $0 {
                FDS.shared.createCustomEntry(
                    mealTime: mealTime,
                    title: customEntry.title,
                    nutrients: .init(
                        kcal: customEntry.nutrients.kcal,
                        carbs: customEntry.nutrients.carbs,
                        proteins: customEntry.nutrients.proteins,
                        fats: customEntry.nutrients.fats
                    )
                )
            }
        }
        
        FDS.shared.addFoodsMeal(
            mealTime: mealTime,
            date: UDM.currentlyWorkingDay,
            mealData: foods.map { food in
                MealData(weight: food.weight ?? 0, food: food)
            }
        )
    }
    
    func createFood() {
        guard let type = self.createFoodType else { return }
        switch type {
        case .food:
            router?.openCreateProduct()
        case .recipe:
            return
        case .meal:
            router?.openCreateMeal(mealTime: getMealTime() ?? .breakfast)
        }
        
        self.createFoodType = nil
    }
    
    func createFood(_ type: FoodCreate) {
        self.createFoodType = type
    }
    
    func getMealTime() -> MealTime? {
        view.getMealTime()
    }
    
    func updateSelectedFoodFromSearch(food: Food) {
        view.updateSelectedFoodFromSearch(food)
    }
    
    func updateSelectedFoodFromCustomEntry(food: Food) {
        view.updateSelectedFoodFromCustomEntry(food)
    }
    
    func updateCustomFood(food: Food) {
        self.foods?.append(food)
	}

    func stopSearchQuery() {
        searchQueue.cancelAllOperations()
    }
    
    func didTapCloseButton() {
        router?.dismissVC()
    }
    
    func getAllMeals() -> [Meal] {
        FDS.shared.getAllMeals()
    }
    
    func openEditMeal(meal: Meal) {
        router?.openEditMeal(meal: meal)
    }
    
    func realoadCollectionView() {
        view.realoadCollectionView()
    }
    
    func dismissToCreateMeal(with food: Food) {
        router?.dismissToCreateMeal(with: food)
    }

}
