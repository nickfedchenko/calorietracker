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
    /// Метода поиска продуктов, по умолчанию локальный
    /// - Parameters:
    ///   - phrase: search query
    ///   - userNetwork: флаг отвечающий за поиск через бэк
    ///   - completion: результат приходит сюда.
    func searchProducts(by phrase: String, useNetwork: Bool, completion: @escaping ([Product]) -> Void)
    /// Связывает модель FoodData с Dish
    /// - Parameters:
    ///   - foodDataId: id модели FoodData
    ///   - dishID: id модели Dish
    func setChildFoodData(foodDataId: String, dishID: Int)
    /// Связывает модель FoodData с Product
    /// - Parameters:
    ///   - foodDataId: id модели FoodData
    ///   - productID: id модели Product
    func setChildFoodData(foodDataId: String, productID: Int)
    /// Связывает модель Meal с Product и Dish
    /// - Parameters:
    ///   - mealId: id модели FoodData
    ///   - dishesID: массив id Dish
    ///   - productsID: массив id Product
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [Int])
    /// Возвращает недавно использованные продукты
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Product
    func getRecentProducts(_ count: Int) -> [Product]
    /// Возвращает недавно использованные блюда
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Dish
    func getRecentDishes(_ count: Int) -> [Dish]
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
    func getRecentProducts(_ count: Int) -> [Product] {
        let allFoodData = self.getFoodData().sorted(by: { $0.dateLastUse <= $1.dateLastUse })
        let foodData = allFoodData.count >= count
            ? Array(allFoodData[0..<count])
            : allFoodData
        
        return foodData.compactMap {
            switch $0.food {
            case .product(let product):
                return product
            default:
                return nil
            }
        }
    }
    
    func getRecentDishes(_ count: Int) -> [Dish] {
        let allFoodData = self.getFoodData().sorted(by: { $0.dateLastUse <= $1.dateLastUse })
        let foodData = allFoodData.count >= count
            ? Array(allFoodData[0..<count])
            : allFoodData
        
        return foodData.compactMap {
            switch $0.food {
            case .dishes(let dish):
                return dish
            default:
                return nil
            }
        }
    }
    
    func setChildFoodData(foodDataId: String, dishID: Int) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, dishID: dishID)
    }
    
    func setChildFoodData(foodDataId: String, productID: Int) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, productID: productID)
    }
    
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [Int]) {
        localPersistentStore.setChildMeal(mealId: mealId, dishesID: dishesID, productsID: productsID)
    }
    
    func updateStoredProducts() {
        networkService.fetchProducts { [weak self] result in
            switch result {
            case .failure(let error):
                dump(error)
            case .success(let products):
                self?.localPersistentStore.saveProducts(products: products)
            }
        }
    }
    
    func updateStoredDishes() {
        networkService.fetchDishes { [weak self] result in
            switch result {
            case .failure(let error):
                dump(error)
            case .success(let dishes):
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
        
}
