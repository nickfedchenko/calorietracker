//
//  DataServiceFacade(DSF).swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 09.08.2022.
//

import Foundation
import NaturalLanguage

protocol DataServiceFacadeInterface {
    /// Метода качает свежий архив продуктов(язык архива завязан на локаль) с бэка и сохраняет в локальной базе.
    func updateStoredProducts()
    /// Метода качает свежий архив продуктов(язык архива завязан на локаль) с бэка и сохраняет в локальной базе.
    func updateStoredDishes()
    /// Возвращает все продукты сохраненные в локальной ДБ
    /// - Returns: массив Product
    func getAllStoredProducts() -> [Product]
    /// Возвращает все блюда сохраненные в локальной ДБ
    /// - Returns: массив Dish
    func getAllStoredDishes() -> [Dish]
    /// Возвращает все данные о еде сохраненные в локальной ДБ
    /// - Returns: массив FoodData
    func getAllStoredFoodData() -> [FoodData]
    /// Возвращает все данные о воде сохраненные в локальной ДБ
    /// - Returns: массив DailyData
    func getAllStoredWater() -> [DailyData]
    /// Метода поиска продуктов, по умолчанию локальный
    /// - Parameters:
    ///   - phrase: search query
    ///   - userNetwork: флаг отвечающий за поиск через бэк
    ///   - completion: результат приходит сюда.
    func searchProducts(by phrase: String, useNetwork: Bool, completion: @escaping ([Product]) -> Void)
    /// Метода поиска продуктов
    /// - Parameters:
    ///   - phrase: search query
    /// - Returns: массив Product
    func searchProducts(by phrase: String) -> [Product]
    /// Метода поиска продуктов
    /// - Parameters:
    ///   - barcode: barcode
    /// - Returns: массив Product
    func searchProducts(barcode: String) -> [Product]
    /// Метода поиска блюд
    /// - Parameters:
    ///   - phrase: search query
    /// - Returns: массив Dish
    func searchDishes(by phrase: String) -> [Dish]
    /// Связывает модель FoodData с Dish
    /// - Parameters:
    ///   - foodDataId: id модели FoodData
    ///   - dishID: id модели Dish
    func setChildFoodData(foodDataId: String, dishID: Int)
    /// Связывает модель FoodData с Product
    /// - Parameters:
    ///   - foodDataId: id модели FoodData
    ///   - productID: id модели Product
    func setChildFoodData(foodDataId: String, productID: String)
    /// Связывает модель Meal с Product и Dish
    /// - Parameters:
    ///   - mealId: id модели FoodData
    ///   - dishesID: массив id Dish
    ///   - productsID: массив id Product
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String])
}

final class DSF {
    static let shared: DataServiceFacadeInterface = DSF()
    
    private let networkService: NetworkEngineInterface = NetworkEngine()
    private let localPersistentStore: LocalDomainServiceInterface = LocalDomainService()
    
    private init() {}
    
    private func getFoodData() -> [FoodData] {
        localPersistentStore.fetchFoodData()
    }
}

extension DSF: DataServiceFacadeInterface {
    
    func setChildFoodData(foodDataId: String, dishID: Int) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, dishID: dishID)
    }
    
    func setChildFoodData(foodDataId: String, productID: String) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, productID: productID)
    }
    
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String]) {
        localPersistentStore.setChildMeal(
            mealId: mealId,
            dishesID: dishesID,
            productsID: productsID
        )
    }
    
    func updateStoredProducts() {
        networkService.fetchProducts { [weak self] result in
            switch result {
            case .failure(let error):
                dump(error)
            case .success(let products):
                self?.localPersistentStore.saveProducts(
                    products: products.map { .init($0) },
                    saveInPriority: false
                )
            }
        }
    }
    
    func updateStoredDishes() {
        networkService.fetchDishes { [weak self] result in
            switch result {
            case .failure(let error):
                dump(error)
            case .success(let dishes):
                print("dishes received \(dishes.count)")
                self?.localPersistentStore.saveDishes(dishes: dishes)
            }
        }
    }
        
    func getAllStoredProducts() -> [Product] {
        let products = localPersistentStore.fetchProducts()
        return products
    }
    
    func getAllStoredDishes() -> [Dish] {
        let dishes = localPersistentStore.fetchDishes()
        return dishes
    }
    
    func getAllStoredFoodData() -> [FoodData] {
        self.getFoodData()
    }
    
    func getAllStoredWater() -> [DailyData] {
        return localPersistentStore.fetchWater()
    }
    
    func searchProducts(by phrase: String, useNetwork: Bool = false, completion: @escaping ([Product]) -> Void) {
        var products = localPersistentStore.searchProducts(by: phrase)
        guard useNetwork else {
            completion(products)
            return
        }
        
        networkService.remoteSearch(by: phrase) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let searchedProducts):
                products.append(contentsOf: searchedProducts.data.compactMap { $0.getConventionalProduct() })
                completion(products.sorted { $0.title.count < $1.title.count })
            }
        }
    }
    
    func searchProducts(by phrase: String) -> [Product] {
        localPersistentStore.searchProducts(by: phrase)
    }
    
    func searchProducts(barcode: String) -> [Product] {
        localPersistentStore.searchProducts(barcode: barcode)
    }
    
    func searchDishes(by phrase: String) -> [Dish] {
        localPersistentStore.searchDishes(by: phrase)
    }
}
