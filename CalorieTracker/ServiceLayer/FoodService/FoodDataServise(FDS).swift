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
    func createMeal(mealTime: MealTime, dishes: [Dish], products: [Product])
    /// Возвращает все приемы пищи
    /// - Returns: массив Meal
    func getAllMeals() -> [Meal]
    /// Возвращает все данные о питание
    /// - Returns: массив DailyNutritionData
    func getAllNutrition() -> [DailyNutritionData]
    /// Возвращает данные о питание за сегодня
    /// - Returns: массив DailyNutritionData
    func getNutritionToday() -> DailyNutritionData
    /// Возвращает данные о питание за выбранный день
    /// - Returns: массив DailyNutritionData
    func getNutritionForDate(_ date: Date) -> DailyNutritionData
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
    /// Записывает в UDM поисковой запрос
    /// - Parameters:
    ///   - query: поисковой запрос
    func rememberSearchQuery(_ query: String)
    /// Возвращает любимые блюда
    /// - Returns: массив Dish
    func getFavoriteDishes() -> [Dish]
    /// Возвращает любимые продукты
    /// - Returns: массив Product
    func getFavoriteProducts() -> [Product]
    /// Возвращает часто используемые блюда
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Dish
    func getFrequentDishes(_ count: Int) -> [Dish]
    /// Возвращает часто используемые продукты
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Product
    func getFrequentProducts(_ count: Int) -> [Product]
    /// Обновляет данные за день
    /// - Parameters:
    ///   - day: дата
    ///   - nutrition: данные
    func addNutrition(day: Day, nutrition: DailyNutrition)
    /// Возвращает циль на дневное питание
    /// - Returns: массив DailyNutrition
    func getNutritionGoals() -> DailyNutrition?
    /// Обновляет данные о продукте или блюде
    /// - Parameters:
    ///   - food: Food продукт или блюдо
    ///   - favorites: избранное
    /// - Returns: FoodData ID
    @discardableResult func foodUpdate(food: Food, favorites: Bool?) -> String?
    /// Возвращает данные о продукте или блюде
    /// - Parameters:
    ///   - food: продукт или блюдо
    /// - Returns: FoodData
    func getFoodData(_ food: Food) -> FoodData?
    /// Возвращает все данные о еде сохраненные в локальной ДБ
    /// - Returns: массив FoodData
    func getAllStoredFoodData() -> [FoodData]
    func getAllStoredDailyMeals() -> [DailyMeal]
    func addFoodsMeal(mealTime: MealTime, date: Day, foods: [Food])
}

final class FDS {
    static let shared: FoodDataServiceInterface = FDS()
    
    private let localPersistentStore: LocalDomainServiceInterface = LocalDomainService()
    
    private func getFavoriteFoods() -> [FoodData] {
        localPersistentStore.fetchFoodData().filter { $0.favorites }
    }
    
    private func getFrequentFood(_ count: Int) -> [FoodData] {
        let allFoods = localPersistentStore.fetchFoodData()
        return Array(allFoods.sorted(by: { $0.numberUses > $1.numberUses })
            .filter { $0.food != nil }
            .prefix(count))
    }
}

extension FDS: FoodDataServiceInterface {
    func addFoodsMeal(mealTime: MealTime, date: Day, foods: [Food]) {
        let productsID = foods.products.map { $0.id }
        let dishesID = foods.dishes.map { $0.id }
        
        guard localPersistentStore.setChildDailyMeal(
            mealTime: mealTime.rawValue,
            date: date,
            dishesID: dishesID,
            productsID: productsID
        ) else {
            let dailyMeal = DailyMeal(
                date: date,
                mealTime: mealTime,
                foods: foods
            )
            
            localPersistentStore.saveDailyMeals(data: [dailyMeal])
            return
        }
    }
    
    func foodUpdate(food: Food, favorites: Bool?) -> String? {
        guard let foodData = localPersistentStore.getFoodData(food) else {
            let foodData = FoodData(
                dateLastUse: Date(),
                favorites: favorites ?? false,
                numberUses: 1
            )
            localPersistentStore.saveFoodData(foods: [foodData])
            
            switch food {
            case .product(let product):
                foodData.setChild(product)
            case .dishes(let dish, _):
                foodData.setChild(dish)
            default:
                return nil
            }
            return foodData.id
        }
        
        localPersistentStore.setFoodData(
            favorites: favorites,
            date: Date(),
            numberUses: foodData.numberUses + 1,
            food: food
        )
        
        return foodData.id
    }
    
    func getFoodData(_ food: Food) -> FoodData? {
        return localPersistentStore.getFoodData(food)
    }
    
    func getAllStoredFoodData() -> [FoodData] {
        return localPersistentStore.fetchFoodData()
    }
    
    func getAllStoredDailyMeals() -> [DailyMeal] {
        localPersistentStore.fetchDailyMeals()
    }
    
    func getFavoriteDishes() -> [Dish] {
        let dishes: [Dish] = getFavoriteFoods().compactMap { food in
            switch food.food {
            case .dishes(let dish, _):
                return dish
            default:
                return nil
            }
        }
        
        return dishes
    }
    
    func getFavoriteProducts() -> [Product] {
        let products: [Product] = getFavoriteFoods().compactMap { food in
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
            case .dishes(let dish, _):
                return dish
            default:
                return nil
            }
        }
        
        return dishes
    }
    
    func getFrequentProducts(_ count: Int) -> [Product] {
        let products: [Product] = getFrequentFood(count).compactMap { food in
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
    
    func getNutritionForDate(_ date: Date) -> DailyNutritionData {
        let day = Day(date)
        return localPersistentStore.fetchNutrition()
            .first(where: { $0.day == day }) ?? .init(day: day, nutrition: .zero)
    }
    
    func createMeal(mealTime: MealTime, dishes: [Dish], products: [Product]) {
        let meal = Meal(mealTime: mealTime)
        localPersistentStore.saveMeals(meals: [meal])
        meal.setChild(dishes: dishes, products: products)
    }
    
    func getRecentProducts(_ count: Int) -> [Product] {
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
            case .dishes(let dish, _):
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
    
    func getNutritionGoals() -> DailyNutrition? {
        guard let kcalGoal = UDM.kcalGoal else {
            return nil
        }
        
        let nutrientPercent = UDM.nutrientPercent ?? .default
        
        return .init(
            kcal: kcalGoal,
            carbs: kcalGoal * nutrientPercent.getNutrientPercent().carbs,
            protein: kcalGoal * nutrientPercent.getNutrientPercent().protein,
            fat: kcalGoal * nutrientPercent.getNutrientPercent().fat
        )
    }
}
