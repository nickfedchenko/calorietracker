//
//  LocalDomainService.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 11.08.2022.
//

import CoreData
import UIKit

protocol LocalDomainServiceInterface {
    func fetchProducts() -> [Product]
    func fetchDishes() -> [Dish]
    func fetchFoodData() -> [FoodData]
    func fetchMeals() -> [Meal]
    func fetchWater() -> [DailyData]
    func fetchSteps() -> [DailyData]
    func fetchWeight() -> [DailyData]
    func fetchNutrition() -> [DailyNutritionData]
    func fetchExercise() -> [Exercise]
    func saveProducts(products: [Product], saveInPriority: Bool)
    func saveDishes(dishes: [Dish])
    func saveFoodData(foods: [FoodData])
    func saveMeals(meals: [Meal])
    func saveWater(data: [DailyData])
    func saveSteps(data: [DailyData])
    func saveWeight(data: [DailyData])
    func saveNutrition(data: [DailyNutritionData])
    func saveExercise(data: [Exercise])
    func searchProducts(by phrase: String) -> [Product]
    func searchProducts(barcode: String) -> [Product]
    func searchDishes(by phrase: String) -> [Dish]
    func setChildFoodData(foodDataId: String, dishID: Int)
    func setChildFoodData(foodDataId: String, productID: String)
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String])
    func setFoodData(favorites: Bool?, date dateLastUse: Date?, numberUses: Int?, food: Food)
    func getFoodData(_ food: Food) -> FoodData?
}

final class LocalDomainService {
    // MARK: - Constants
    
    enum Constants {
        static let modelName: String = "CaloireTrackerLocal"
    }
    
    private static let model = NSManagedObjectModel(
        contentsOf: Bundle.main.url(forResource: Constants.modelName, withExtension: "momd")!
    )
    
    // MARK: - Public Properties
    
    private var container: NSPersistentContainer = {
        guard let model = LocalDomainService.model else {
            fatalError("Error instantiating CoreData model")
        }
        
        let container = NSPersistentContainer(name: Constants.modelName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        let context = container.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    private lazy var taskContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        return context
    }()
    
    // MARK: - Public Methods
    
    private func save() {
        guard taskContext.hasChanges else {
            return
        }
        taskContext.perform { [weak taskContext] in
            do {
                 try taskContext?.save()
            } catch let error {
                taskContext?.rollback()
                print(error)
            }
        }
    }
    
    private func deleteObject<T: NSManagedObject> (object: T) {
        context.delete(object)
        save()
    }
    
    private func fetchData<T: NSManagedObject> (
        for entity: T.Type,
        withPredicate predicate: NSCompoundPredicate? = nil,
        withSortDescriptor sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T]? {
        
        var fetchedResult: [T]?
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            fetchedResult = try context.fetch(request) as? [T]
        } catch {
            debugPrint("Error occurred: \(error.localizedDescription)")
        }
        return fetchedResult
    }
    
    func getDomainFoodData(_ food: Food) -> DomainFoodData? {
        let format = "id == %@"
        let productRequest = NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
        productRequest.predicate = NSPredicate(format: format, food.id)
        
        guard let product = try? context.fetch(productRequest).first,
                let domainFoodData = product.foodData else {
            return nil
        }
        
        return domainFoodData
    }
}

// MARK: - LocalDomainServiceInterface
extension LocalDomainService: LocalDomainServiceInterface {

    func fetchProducts() -> [Product] {
        guard let domainProducts = fetchData(for: DomainProduct.self) else { return [] }
        return domainProducts.compactMap { Product(from: $0) }
    }
    
    func fetchDishes() -> [Dish] {
        guard let domainDishes = fetchData(for: DomainDish.self) else {
            return []
        }
        return domainDishes.compactMap { Dish(from: $0) }
    }
    
    func fetchFoodData() -> [FoodData] {
        guard let domainFoodData = fetchData(for: DomainFoodData.self) else { return [] }
        return domainFoodData.compactMap { FoodData(from: $0) }
    }
    
    func fetchMeals() -> [Meal] {
        guard let domainMeals = fetchData(for: DomainMeal.self) else { return [] }
        return domainMeals.compactMap { Meal(from: $0) }
    }
    
    func fetchWater() -> [DailyData] {
        guard let domainWater = fetchData(for: DomainWater.self) else { return [] }
        return domainWater.compactMap { DailyData(from: $0) }
    }
    
    func fetchSteps() -> [DailyData] {
        guard let domainSteps = fetchData(for: DomainSteps.self) else { return [] }
        return domainSteps.compactMap { DailyData(from: $0) }
    }
    
    func fetchWeight() -> [DailyData] {
        guard let domainWeight = fetchData(for: DomainWeight.self) else { return [] }
        return domainWeight.compactMap { DailyData(from: $0) }
    }
    
    func fetchNutrition() -> [DailyNutritionData] {
        guard let domainNutrition = fetchData(for: DomainNutrition.self) else {
            return []
        }
        return domainNutrition.compactMap { DailyNutritionData(from: $0) }
    }
    
    func fetchExercise() -> [Exercise] {
        guard let domainExercise = fetchData(for: DomainExercise.self) else {
            return []
        }
        return domainExercise.compactMap { Exercise(from: $0) }
    }
    
    func saveProducts(products: [Product], saveInPriority: Bool) {
        let _: [DomainProduct] = products
            .map { DomainProduct.prepare(fromPlainModel: $0, context: context) }
        
        if saveInPriority {
            try? context.save()
        } else {
            save()
        }
    }
    
    func saveDishes(dishes: [Dish]) {
        let _: [DomainDish] = dishes
            .map { DomainDish.prepare(fromPlainModel: $0, context: taskContext) }
        save()
    }
    
    func saveMeals(meals: [Meal]) {
        let _: [DomainMeal] = meals
            .map { DomainMeal.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveWater(data: [DailyData]) {
        let _: [DomainWater] = data
            .map { DomainWater.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveSteps(data: [DailyData]) {
        let _: [DomainSteps] = data
            .map { DomainSteps.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveWeight(data: [DailyData]) {
        let _: [DomainWeight] = data
            .map { DomainWeight.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveNutrition(data: [DailyNutritionData]) {
        let _: [DomainNutrition] = data
            .map { DomainNutrition.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveExercise(data: [Exercise]) {
        let _: [DomainExercise] = data
            .map { DomainExercise.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func setChildFoodData(foodDataId: String, dishID: Int) {
        let format = "id == %ld"
        let formatStrId = "id == %@"
        let dishRequest = NSFetchRequest<DomainDish>(entityName: "DomainDish")
        let foodDataRequest = NSFetchRequest<DomainFoodData>(entityName: "DomainFoodData")
        
        dishRequest.predicate = NSPredicate(format: format, dishID)
        foodDataRequest.predicate = NSPredicate(format: formatStrId, foodDataId)
        
        guard let dish = try? context.fetch(dishRequest).first,
              let foodData = try? context.fetch(foodDataRequest).first else { return }
        
        foodData.dish = dish
        foodData.product = nil
        
        try? context.save()
    }
    
    func setChildFoodData(foodDataId: String, productID: String) {
        let format = "id == %@"
        let productRequest = NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
        let foodDataRequest = NSFetchRequest<DomainFoodData>(entityName: "DomainFoodData")

        productRequest.predicate = NSPredicate(format: format, productID)
        foodDataRequest.predicate = NSPredicate(format: format, foodDataId)
        
        guard let product = try? context.fetch(productRequest).first,
              let foodData = try? context.fetch(foodDataRequest).first else { return }
        
        foodData.product = product
        foodData.dish = nil
        
        try? context.save()
    }
    
    func setFoodData(favorites: Bool?, date dateLastUse: Date?, numberUses: Int?, food: Food) {
        guard let foodData = getDomainFoodData(food) else { return }
        
        if let favorites = favorites {
            foodData.favorites = favorites
        }
        
        if let dateLastUse = dateLastUse {
            foodData.dateLastUse = dateLastUse
        }
        
        if let numberUses = numberUses {
            foodData.numberUses = Int32(numberUses)
        }
        
        try? context.save()
    }
    
    func getFoodData(_ food: Food) -> FoodData? {
        guard let domainFoodData = getDomainFoodData(food) else {
            return nil
        }
        
        return FoodData(from: domainFoodData)
    }
    
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String]) {
        let format = "id == %ld"
        let formatMeal = "id == %@"
        
        let dishPredicates = dishesID.map { NSPredicate(format: format, $0) }
        let productPredicates = productsID.map { NSPredicate(format: formatMeal, $0) }
        let mealPredicate = NSPredicate(format: formatMeal, mealId)
        
        let products = productPredicates.compactMap {
            fetchData(
                for: DomainProduct.self,
                withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [$0])
            )?.first
        }
        
        let dishes = dishPredicates.compactMap {
            fetchData(
                for: DomainDish.self,
                withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [$0])
            )?.first
        }
        
        guard let meal = fetchData(
            for: DomainMeal.self,
            withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [mealPredicate])
        )?.first else { return }
        
        meal.addToDishes(NSSet(array: dishes))
        meal.addToProducts(NSSet(array: products))
        
        try? context.save()
    }
    
    func getFoodData(_ id: String) -> FoodData? {
        let predicate = NSPredicate(format: "id == %@", id)
        
        let domainFoodData = fetchData(
            for: DomainFoodData.self,
            withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
        )?.first
        
        guard let domainFoodData = domainFoodData else {
            return nil
        }
        
        return FoodData(from: domainFoodData)
    }
    
    func saveFoodData(foods: [FoodData]) {
        let _: [DomainFoodData] = foods
            .map { DomainFoodData.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func searchProducts(by phrase: String) -> [Product] {
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", phrase)
        let brandPredicate = NSPredicate(format: "brand CONTAINS[cd] %@", phrase)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, brandPredicate])
     
        guard let products = fetchData(
            for: DomainProduct.self,
            withPredicate: compoundPredicate
        ) else {
            return []
        }
        return products.compactMap { Product(from: $0) }.sorted { $0.title.count < $1.title.count }
    }
    
    func searchProducts(barcode: String) -> [Product] {
        let barcodePredicate = NSPredicate(format: "barcode CONTAINS[cd] %@", barcode)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [barcodePredicate])
     
        guard let products = fetchData(
            for: DomainProduct.self,
            withPredicate: compoundPredicate
        ) else {
            return []
        }
        return products.compactMap { Product(from: $0) }.sorted { $0.title.count < $1.title.count }
    }
    
    func searchDishes(by phrase: String) -> [Dish] {
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", phrase)
       
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate])
     
        guard let products = fetchData(
            for: DomainDish.self,
            withPredicate: compoundPredicate
        ) else {
            return []
        }
//        return products.compactMap { Dish(from: $0) }.sorted { $0.title.count < $1.title.count }
        return []
    }
}
