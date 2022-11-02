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
}

final class FDS {
    static let shared: FoodDataServiceInterface = FDS()
    
    private let localPersistentStore: LocalDomainServiceInterface = LocalDomainService()
}

extension FDS: FoodDataServiceInterface {
    func getAllMeals() -> [Meal] {
        localPersistentStore.fetchMeals()
    }
    
    func createMeal(mealTime: MealTime, dishes: [Dish], products: [Product]) {
        let meal = Meal(mealTime: mealTime)
        localPersistentStore.saveMeals(meals: [meal])
        meal.setChild(dishes: dishes, products: products)
    }
}
