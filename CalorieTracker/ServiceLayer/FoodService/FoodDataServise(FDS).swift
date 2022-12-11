//
//  FoodDataServise(FDS).swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.11.2022.
//

import Foundation

protocol FoodDataServiceInterface {
    /// Создает и сохраняет в БД модель Meal и привязывает к ней продукты и блюда
    /// - Parameters:
    ///   - mealTime: время приема еды
    ///   - dishes: массив блюд
    ///   - products: массив продуктов
    func createMeal(mealTime: MealTime, dishes: [Dish], products: [ProductDTO])
    /// Возвращает все приемы пищи
    /// - Returns: массив Meal
    func getAllMeals() -> [Meal]
    /// Возвращает все данные о питание
    /// - Returns: массив DailyNutritionData
    func getAllNutrition() -> [DailyNutritionData]
    /// Возвращает данные о питание за сегодня
    /// - Returns: массив DailyNutritionData
    func getNutritionToday() -> DailyNutritionData
    /// Возвращает недавно использованные продукты
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Product
    func getRecentProducts(_ count: Int) -> [ProductDTO]
    /// Возвращает недавно использованные блюда
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Dish
    func getRecentDishes(_ count: Int) -> [Dish]
    /// Записывает в UDM поисковой запрос
    /// - Parameters:
    ///   - query: поисковой запрос
    func rememberSearchQuery(_ query: String)
    /// Возвращает любимые блюда
    /// - Returns: массив Dish
    func getFavoriteDishes() -> [Dish]
    /// Возвращает любимые продукты
    /// - Returns: массив Product
    func getFavoriteProducts() -> [ProductDTO]
    /// Возвращает часто используемые блюда
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Dish
    func getFrequentDishes(_ count: Int) -> [Dish]
    /// Возвращает часто используемые продукты
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Product
    func getFrequentProducts(_ count: Int) -> [ProductDTO]
    /// Обновляет данные за день
    /// - Parameters:
    ///   - day: дата
    ///   - nutrition: данные
    func addNutrition(day: Day, nutrition: DailyNutrition)
}

final class FDS {
    static let shared: FoodDataServiceInterface = FDS()
    
    private let localPersistentStore: LocalDomainServiceInterface = LocalDomainService()
    
    private func getFavoriteFoods() -> [FoodData] {
        DSF.shared.getAllStoredFoodData().filter { $0.favorites }
    }
    
    private func getFrequentFood(_ count: Int) -> [FoodData] {
        let allFoods = DSF.shared.getAllStoredFoodData()
        return Array(allFoods.sorted(by: { $0.numberUses > $1.numberUses })
            .filter { $0.food != nil }
            .prefix(count))
    }
}

extension FDS: FoodDataServiceInterface {
    func getFavoriteDishes() -> [Dish] {
        let dishes: [Dish] = getFavoriteFoods().compactMap { food in
            switch food.food {
            case .dishes(let dish):
                return dish
            default:
                return nil
            }
        }
        
        return dishes
    }
    
    func getFavoriteProducts() -> [ProductDTO] {
        let products: [ProductDTO] = getFavoriteFoods().compactMap { food in
            switch food.food {
            case .product(let product):
                return product
            default:
                return nil
            }
        }
        
        return products
    }
    
    func getFrequentDishes(_ count: Int) -> [Dish] {
        let dishes: [Dish] = getFrequentFood(count).compactMap { food in
            switch food.food {
            case .dishes(let dish):
                return dish
            default:
                return nil
            }
        }
        
        return dishes
    }
    
    func getFrequentProducts(_ count: Int) -> [ProductDTO] {
        let products: [ProductDTO] = getFrequentFood(count).compactMap { food in
            switch food.food {
            case .product(let product):
                return product
            default:
                return nil
            }
        }
        
        return products
    }
    
    func getAllMeals() -> [Meal] {
        localPersistentStore.fetchMeals()
    }
    
    func getAllNutrition() -> [DailyNutritionData] {
        localPersistentStore.fetchNutrition()
    }
    
    func getNutritionToday() -> DailyNutritionData {
        let today = Day(Date())
        return localPersistentStore.fetchNutrition()
            .first(where: { $0.day == today }) ?? .init(day: today, nutrition: .zero)
    }
    
    func createMeal(mealTime: MealTime, dishes: [Dish], products: [ProductDTO]) {
        let meal = Meal(mealTime: mealTime)
        localPersistentStore.saveMeals(meals: [meal])
        meal.setChild(dishes: dishes, products: products)
    }
    
    func getRecentProducts(_ count: Int) -> [ProductDTO] {
        let allFoodData = localPersistentStore.fetchFoodData()
            .sorted(by: { $0.dateLastUse <= $1.dateLastUse })
            .filter { $0.food != nil }
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
        let allFoodData = localPersistentStore.fetchFoodData()
            .sorted(by: { $0.dateLastUse <= $1.dateLastUse })
            .filter { $0.food != nil }
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
    
    func rememberSearchQuery(_ query: String) {
        let countSearchQuery = 10
        
        var searchHistory = UDM.searchHistory
        searchHistory.insert(query, at: 0)
        
        UDM.searchHistory = Array(Set(
            searchHistory.count >= countSearchQuery
            ? Array(searchHistory[0..<countSearchQuery])
            : searchHistory
        ))
    }
    
    func addNutrition(day: Day, nutrition: DailyNutrition) {
        let oldNutrition = localPersistentStore.fetchNutrition()
            .first(where: { $0.day == day }) ?? .init(day: day, nutrition: .zero)
        let newNutrition: DailyNutritionData = .init(
            day: day,
            nutrition: oldNutrition.nutrition + nutrition
        )
        localPersistentStore.saveNutrition(data: [newNutrition])
    }
}
