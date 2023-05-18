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
    ///   - title: название
    ///   - photo: фото
    ///   - foods: список ингридиентов
    func createMeal(mealTime: MealTime, title: String, photoURL: String, foods: [Food])
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
    func getRecentProducts(_ count: Int) -> [Food]
    /// Возвращает недавно использованные блюда
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Dish
    func getRecentDishes(_ count: Int) -> [Food]
    /// Возвращает недавно использованный кастомный ввод
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив CustomEntry
    func getRecentCustomEntries(_ count: Int) -> [Food]
    /// Записывает в UDM поисковой запрос
    /// - Parameters:
    ///   - query: поисковой запрос
    func rememberSearchQuery(_ query: String)
    /// Возвращает любимые блюда
    /// - Returns: массив Dish
    func getFavoriteDishes() -> [Food]
    /// Возвращает любимые продукты
    /// - Returns: массив Product
    func getFavoriteProducts() -> [Food]
    /// Возвращает часто используемые блюда
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Dish
    func getFrequentDishes(_ count: Int) -> [Food]
    /// Возвращает часто используемые продукты
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив Product
    func getFrequentProducts(_ count: Int) -> [Food]
    /// Возвращает часто используемый кастомный ввод
    /// - Parameters:
    ///   - count: количество результатов
    /// - Returns: массив CustomEntry
    func getFrequentCustomEntries(_ count: Int) -> [Food]
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
    @discardableResult func deleteMealData(_ id: String) -> Bool
    func getAllStoredFoodData() -> [FoodData]
    func getAllStoredDailyMeals() -> [DailyMeal]
    func addFoodsMeal(mealTime: MealTime, date: Day, mealData: [MealData])
    func createCustomEntry(mealTime: MealTime, title: String, nutrients: CustomEntryNutrients)
    func getAllCustomEntries() -> [CustomEntry]
    func deleteCustomEntry(_ id: String)
    func saveFoodData(foods: [FoodData])
    func updateMeal(meal: Meal)
    func getProduct(by id: String) -> Product?
    func getDish(by id: String) -> Dish?
    func getCustomEntry(by id: String) -> CustomEntry?
    func saveProduct(product: Product)
    func foodUpdateNew(food: Food, favorites: Bool?) -> String?
}

final class FDS {
    static let shared: FoodDataServiceInterface = FDS()
    
    private let localPersistentStore: LocalDomainServiceInterface = LocalDomainService()
    
    private func getFavoriteFoods() -> [FoodData] {
        localPersistentStore.fetchFoodData().filter { $0.favorites }
    }
    
    private func getFrequentFood(_ count: Int) -> [FoodData] {
        let sortDescriptor = NSSortDescriptor(key: "numberOfUses", ascending: false)
        let frequentFood = localPersistentStore.fetchFoodData(with: count, sortDescriptor: sortDescriptor)
        return frequentFood
    }
    
    private func getFrequentFoodNew(_ count: Int) -> [FoodData] {
        let sortDescriptor = NSSortDescriptor(key: "numberOfUses", ascending: false)
        let frequentFood = localPersistentStore.fetchFoodData(with: count, sortDescriptor: sortDescriptor)
        return frequentFood
    }
    
    private func dailyMealConverNutrients(_ dailyMeal: [DailyMeal]) -> DailyNutrition {
        let mealData = dailyMeal.flatMap { $0.mealData }
        
        var protein: Double = 0
        var fat: Double = 0
        var carbs: Double = 0
        var kcal: Double = 0
        
        mealData.forEach {
            switch $0.food {
            case .product(let product, _, let unitData):
                guard let serving = product.servings?.first?.weight else { return }
                protein += product.protein / serving * $0.weight
                fat += product.fat / serving * $0.weight
                carbs += product.carbs / serving * $0.weight
                kcal += product.kcal / serving * $0.weight
            case  .dishes(let dish, _):
                if let dishWeight = dish.dishWeight {
                    protein += dish.protein / dishWeight * $0.weight
                    fat += dish.fat / dishWeight * $0.weight
                    carbs += dish.carbs / dishWeight * $0.weight
                    kcal += dish.kcal / dishWeight * $0.weight
                }
            case .customEntry(let customEntry):
                protein += customEntry.nutrients.proteins
                fat += customEntry.nutrients.fats
                carbs += customEntry.nutrients.carbs
                kcal += customEntry.nutrients.kcal
            case .meal(let meal):
                protein += meal.nutrients.proteins
                fat += meal.nutrients.fats
                carbs += meal.nutrients.carbs
                kcal += meal.nutrients.kcal
                
            default:
                break
            }
        }
        
        return .init(
            kcal: kcal,
            carbs: carbs,
            protein: protein,
            fat: fat
        )
    }
}

extension FDS: FoodDataServiceInterface {
    
    func deleteMealData(_ id: String) -> Bool {
        localPersistentStore.deleteMealData(id)
    }
    
    func addFoodsMeal(mealTime: MealTime, date: Day, mealData: [MealData]) {
        let mealDataId = mealData.map { $0.id }
        
        localPersistentStore.saveMealData(data: mealData)
        mealData.forEach {
            var dishId: Int?
            var productId: String?
            var customEntryId: String?
            var mealId: String?
            
            switch $0.food {
            case .dishes(let dish, _):
                dishId = dish.id
            case .product(let product, _, _):
                productId = product.id
            case .customEntry(let customEntry):
                customEntryId = customEntry.id
            case .meal(let meal):
                mealId = meal.id
            default:
                break
            }
            
            localPersistentStore.setChildMealData(
                mealDataId: $0.id,
                dishID: dishId,
                productID: productId,
                customEntryID: customEntryId,
                mealID: mealId
            )
        }
        
        guard localPersistentStore.setChildDailyMeal(
            mealTime: mealTime.rawValue,
            date: date,
            mealDataId: mealDataId
        ) else {
            let dailyMeal = DailyMeal(
                date: date,
                mealTime: mealTime,
                mealData: []
            )
            
            localPersistentStore.saveDailyMeals(data: [dailyMeal])
            localPersistentStore.setChildDailyMeal(
                mealTime: mealTime.rawValue,
                date: date,
                mealDataId: mealDataId
            )
            
            return
        }
    }
    
    func saveFoodData(foods: [FoodData]) {
        localPersistentStore.saveFoodData(foods: foods)
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
            case .product(let product, _, _):
                foodData.setChild(product)
            case .dishes(let dish, _):
                foodData.setChild(dish)
            case .customEntry(let customEntry):
                foodData.setChild(customEntry)
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
    
    func foodUpdateNew(food: Food, favorites: Bool?) -> String? {
        return localPersistentStore.updateFoodData(
            food,
            incrementingUses: 1,
            dateLastUsed: Date(),
            isFavorite: favorites
        )
//        guard let foodData = localPersistentStore.updateFoodData(
//            food,
//            incrementingUses: 1,
//            dateLastUsed: Date(),
//            isFavorite: favorites
//        ) else {
//            let foodData = FoodData(
//                dateLastUse: Date(),
//                favorites: favorites ?? false,
//                numberUses: 1
//            )
//            localPersistentStore.saveFoodData(foods: [foodData])
//
//            switch food {
//            case .product(let product, _, _):
//                foodData.setChild(product)
//            case .dishes(let dish, _):
//                foodData.setChild(dish)
//            case .customEntry(let customEntry):
//                foodData.setChild(customEntry)
//            default:
//                return nil
//            }
//            return foodData.id
//        }
//
//        localPersistentStore.setFoodData(
//            favorites: favorites,
//            date: Date(),
//            numberUses: foodData.numberUses + 1,
//            food: food
//        )
//
//        return foodData.id
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
    
    func getFavoriteDishes() -> [Food] {
        let favoriteFood: [FoodData] = getFavoriteFoods()
        let dishes: [Food] = favoriteFood.compactMap { food in
            switch food.food {
            case .dishes(var dish, customAmount: let amount):
                dish.foodDataId = food.food?.foodDataId
                dish.isFavorite = true
                return .dishes(dish, customAmount: amount)
            default:
                return nil
            }
        }
       
        return dishes			
    }
    
    func getFavoriteProducts() -> [Food] {
        let products: [Food] = getFavoriteFoods().compactMap { food in
            switch food.food {
            case .product:
                return food.food
            default:
                return nil
            }
        }
        return products
    }
    
    func getFrequentDishes(_ count: Int) -> [Food] {
        let dishes: [Food] = getFrequentFood(count).compactMap {
            switch $0.food {
            case .dishes:
                return $0.food
            default:
                return nil
            }
        }
        return dishes
    }
    
    func getFrequentProducts(_ count: Int) -> [Food] {
        let products: [Food] = getFrequentFood(count).compactMap {
            switch $0.food {
            case .product:
                return $0.food
            default:
                return nil
            }
        }
        
        return products
    }
    
    func getFrequentCustomEntries(_ count: Int) -> [Food] {
        let customEntries: [Food] = getFrequentFood(count) .compactMap { food in
            switch food.food {
            case .customEntry:
                return food.food
            default:
                return nil
            }
        }
        
        return customEntries
    }
    
    func getAllMeals() -> [Meal] {
        localPersistentStore.fetchMeals()
    }
    
    func getAllNutrition() -> [DailyNutritionData] {
        let dailyMeals = localPersistentStore.fetchDailyMeals()
        
        return dailyMeals.map {
            DailyNutritionData(
                day: $0.date,
                nutrition: dailyMealConverNutrients([$0])
            )
        }
    }
    
    func getNutritionToday() -> DailyNutritionData {
        let today = Date()
        return getNutritionForDate(today)
    }
    
    func getNutritionForDate(_ date: Date) -> DailyNutritionData {
        let day = Day(date)
        let nutrients = dailyMealConverNutrients(
            localPersistentStore.fetchDailyMeals().filter { $0.date == day }
        )
        
        return .init(
            day: day,
            nutrition: nutrients
        )
    }
    
    func createMeal(mealTime: MealTime, title: String, photoURL: String, foods: [Food]) {
        let meal = Meal(mealTime: mealTime, title: title, photoURL: photoURL, foods: foods)
        localPersistentStore.saveMeals(meals: [meal])
//        meal.setChild(dishes: foods.dishes, products: foods.products, customEntries: foods.customEntries)
    }
    
    func updateMeal(meal: Meal) {
        localPersistentStore.updateMeal(meal: meal)
    }
    
    func createCustomEntry(mealTime: MealTime, title: String, nutrients: CustomEntryNutrients) {
        var customEntry = CustomEntry(title: title, nutrients: nutrients, mealTime: mealTime)
        localPersistentStore.saveCustomEntries(entries: [customEntry])
        
        let mealData = MealData(weight: 0.0, food: .customEntry(customEntry))
        addFoodsMeal(mealTime: mealTime, date: UDM.currentlyWorkingDay, mealData: [mealData])
        
        foodUpdateNew(food: .customEntry(customEntry), favorites: false)
    }
    
    func getAllCustomEntries() -> [CustomEntry] {
        localPersistentStore.fetchCustomEntries()
    }
    
    func deleteCustomEntry(_ id: String) {
        localPersistentStore.deleteCustomEntry(id)
    }
    
    func getRecentProducts(_ count: Int) -> [Food] {
        let descriptor = NSSortDescriptor(key: "dateLastUse", ascending: false)
        let allFoodData = localPersistentStore.fetchFoodData(with: count, sortDescriptor: descriptor)
        return allFoodData.compactMap {
            switch $0.food {
            case .product(let product, customAmount: _, unit: _):
                return $0.food
            default:
                return nil
            }
        }
    }
    
    func getRecentDishes(_ count: Int) -> [Food] {
        let descriptor = NSSortDescriptor(key: "dateLastUse", ascending: false)
        let allFoodData = localPersistentStore.fetchFoodData(with: count, sortDescriptor: descriptor)
        return allFoodData.compactMap {
            switch $0.food {
            case .dishes:
                return $0.food
            default:
                return nil
            }
        }
    }
    
    func getRecentCustomEntries(_ count: Int) -> [Food] {
        let allFoodData = localPersistentStore.fetchFoodData()
            .sorted(by: { $0.dateLastUse >= $1.dateLastUse })
            .filter { $0.food != nil }
        let foodData = allFoodData.count >= count
            ? Array(allFoodData[0..<count])
            : allFoodData
        
        return foodData.compactMap {
            switch $0.food {
            case .customEntry:
                return $0.food
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
    
    func getProduct(by id: String) -> Product? {
        guard let domainProduct =  localPersistentStore.getDomainProduct(id) else { return nil }
        return Product(from: domainProduct)
    }
    
    func getDish(by id: String) -> Dish? {
        guard let domainDish =  localPersistentStore.getDomainDish(Int(id) ?? -1) else { return nil }
        return Dish(from: domainDish)
    }
    
    func getCustomEntry(by id: String) -> CustomEntry? {
        guard let domainCustomEntry = localPersistentStore.getDomainCustomEntry(id) else { return nil }
        return CustomEntry(from: domainCustomEntry)
    }
    
    func saveProduct(product: Product) {
        localPersistentStore.saveProducts(products: [product], saveInPriority: true)
    }
}
