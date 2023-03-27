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
    func getAllStoredDishes(completion: @escaping ([Dish]) -> Void)
    /// Возвращает все заметки сохраненные в локальной ДБ
    /// - Returns: массив Note
    func getAllStoredNotes() -> [Note]
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
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String], customEntriesID: [String])
    func setChildFoodData(foodDataId: String, customEntryID: String)
//    func getProduct(by id: String) -> DomainProduct
//    func getDish(by id: String) -> DomainDish
//    func getCustomEntry(by id: String) -> DomainDish
    func getBreakfastDishes(completion: @escaping ([Dish]) -> Void)
    func getLunchDishes(completion: @escaping ([Dish]) -> Void)
    func getDinnerDishes(completion: @escaping ([Dish]) -> Void)
    func getSnacksDishes(completion: @escaping ([Dish]) -> Void)
    
    func saveExercises(_ exercises: [Exercise])
    func saveSteps(_ steps: [DailyData])
}

final class DSF {
    static let shared: DataServiceFacadeInterface = DSF()
    
    private let networkService: NetworkEngineInterface = NetworkEngine()
    private let localPersistentStore: LocalDomainServiceInterface = LocalDomainService()
    private let mappingQueue: DispatchQueue = DispatchQueue(label: "mappingQueue", qos: .userInitiated)

    private init() {}
}

extension DSF: DataServiceFacadeInterface {
    func getLunchDishes(completion: @escaping ([Dish]) -> Void) {
        localPersistentStore.fetchLunchDishes() { [weak self] dishes in
            
//            self?.mappingQueue.async {
                let startTime = Date().timeIntervalSince1970
                let normalDishes = dishes?.compactMap { Dish(from: $0) }
                let endTime = Date().timeIntervalSince1970
                print("lunch dishes mapping time \(endTime - startTime)")
                completion(normalDishes ?? [])
//            }
        }
    }
    
    func getDinnerDishes(completion: @escaping ([Dish]) -> Void) {
        localPersistentStore.fetchDinnerDishes { [weak self] dishes in
//            self?.mappingQueue.async {
                let startTime = Date().timeIntervalSince1970
                let normalDishes = dishes?.compactMap { Dish(from: $0) }
                let endTime = Date().timeIntervalSince1970
                print("dinner dishes mapping time \(endTime - startTime)")
                completion(normalDishes ?? [])
//            }
        }
    }
    
    func getSnacksDishes(completion: @escaping ([Dish]) -> Void) {
        localPersistentStore.fetchSnackDishes { [weak self] dishes in
//            self?.mappingQueue.async {
                let startTime = Date().timeIntervalSince1970
                let normalDishes = dishes?.compactMap { Dish(from: $0) }
                let endTime = Date().timeIntervalSince1970
                print("snack dishes mapping time \(endTime - startTime)")
                completion(normalDishes ?? [])
//            }
        }
    }
    
    func getBreakfastDishes(completion: @escaping ([Dish]) -> Void) {
        localPersistentStore.fetchBreakfastDishes { [weak self] dishes in
//            self?.mappingQueue.async {
                let startTime = Date().timeIntervalSince1970
                let normalDishes = dishes?.compactMap { Dish(from: $0) }
                let endTime = Date().timeIntervalSince1970
                print("breakfast dishes mapping time \(endTime - startTime)")
                completion(normalDishes ?? [])
//            }
        }
    }
    
    func saveExercises(_ exercises: [Exercise]) {
        localPersistentStore.saveExercise(data: exercises)
    }
    
    func saveSteps(_ steps: [DailyData]) {
        localPersistentStore.saveSteps(data: steps)
    }
    
    func setChildFoodData(foodDataId: String, dishID: Int) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, dishID: dishID)
    }
    
    func setChildFoodData(foodDataId: String, productID: String) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, productID: productID)
    }
    
    func setChildFoodData(foodDataId: String, customEntryID: String) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, customEntryID: customEntryID)
    }
    
    func setChildFoodData(foodDataId: String, mealID: String) {
        localPersistentStore.setChildFoodData(foodDataId: foodDataId, mealID: mealID)
    }
    
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String], customEntriesID: [String]) {
        localPersistentStore.setChildMeal(
            mealId: mealId,
            dishesID: dishesID,
            productsID: productsID,
            customEntriesID: customEntriesID
        )
    }
    
    func updateStoredProducts() {
        networkService.fetchProducts { [weak self] result in
            switch result {
            case .failure(let error):
                dump(error)
            case .success(let products):
                UDM.lastBaseUpdateDay = Date()
                print("Got \(products.count)")
                let convProduct: [Product] = products.map { .init($0) }
                let splittedProducts = convProduct.splitInSubArrays(into: 8)
                splittedProducts.forEach { [weak self] in
                    self?.localPersistentStore.saveProducts(
                        products: $0,
                        saveInPriority: false
                    )
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 40) { [weak self] in
                   let products = self?.localPersistentStore.fetchProducts()
                    print("got fetched \(products?.count) products")
                }
            }
        }
    }
    
    func updateStoredDishes() {
        networkService.fetchDishes { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let dishes):
                UDM.lastBaseUpdateDay = Date()
                print("dishes received \(dishes.count)")
                let splitDishes = dishes.splitInSubArrays(into: 8)
                self?.makeTagTitles(from: dishes)
                splitDishes.forEach { [weak self] dishes in
                    self?.localPersistentStore.saveDishes(dishes: dishes)
                }
            }
        }
    }
        
    func getAllStoredProducts() -> [Product] {
        let products = localPersistentStore.fetchProducts()
        return products
    }
    
    func getAllStoredDishes(completion: @escaping ([Dish]) -> Void) {
        let dishes = localPersistentStore.fetchDishesAsynchronously(completion: completion)
    }
    
    func getAllStoredWater() -> [DailyData] {
        return localPersistentStore.fetchWater()
    }
    
    func getAllStoredNotes() -> [Note] {
        return localPersistentStore.fetchNotes()
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
    
    private func makeTagTitles(from allDishes: [Dish]) {
        var possibleFilterTags: Set<AdditionalTag> = []
        var possibleExceptionTags: Set<ExceptionTag> = []
        allDishes.forEach {
            $0.additionalTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.dietTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.dishTypeTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.eatingTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            
            $0.processingTypeTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.exceptionTags.forEach {
                possibleExceptionTags.update(with: $0)
            }
        }
        
        UDM.possibleIngredientsTags = possibleExceptionTags
        
        for tag in possibleFilterTags {
            guard let convTag = tag.convenientTag else { continue }
            UDM.titlesForFilterTags[convTag] = tag.title
        }
        
        for tag in possibleExceptionTags {
            guard let convTag = tag.convenientTag else { continue }
            UDM.titlesForExceptionTags[convTag] = tag.title
        }
        UDM.titlesForFilterTags[.favorite] = "Favorites".localized
    }
    
}
