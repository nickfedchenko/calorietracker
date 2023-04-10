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
    func fetchBreakfastDishes(completion: @escaping ([DomainDish]?) -> Void)
    func fetchLunchDishes(completion: @escaping ([DomainDish]?) -> Void)
    func fetchDinnerDishes(completion: @escaping ([DomainDish]?) -> Void)
    func fetchSnackDishes(completion: @escaping ([DomainDish]?) -> Void)
    func fetchDishesAsynchronously(completion: @escaping ([Dish]) -> Void)
    func fetchFoodData() -> [FoodData]
    func fetchMeals() -> [Meal]
    func fetchWater() -> [DailyData]
    func fetchSteps() -> [DailyData]
    func fetchWeight() -> [DailyData]
    func fetchExercise() -> [Exercise]
    func fetchNotes() -> [Note]
    func fetchDailyMeals() -> [DailyMeal]
    func fetchBurnedKcals() -> [DailyData]
    func saveProducts(products: [Product], saveInPriority: Bool)
    func saveDishes(dishes: [Dish])
    func saveFoodData(foods: [FoodData])
    func saveBurnedKcal(data: [DailyData])
    func saveMeals(meals: [Meal])
    func saveWater(data: [DailyData])
    func saveSteps(data: [DailyData])
    func saveWeight(data: [DailyData])
    func saveExercise(data: [Exercise])
    func saveNotes(data: [Note])
    func saveDailyMeals(data: [DailyMeal])
    func saveMealData(data: [MealData])
    func saveCustomEntries(entries: [CustomEntry])
    func fetchCustomEntries() -> [CustomEntry]
    func deleteCustomEntry(_ id: String)
    func searchProducts(by phrase: String, completion: @escaping ([Product]) -> Void)
    func searchProducts(barcode: String, completion: @escaping ([Product]) -> Void)
    func searchDishes(by phrase: String, completion: @escaping ([Dish]) -> Void)
    func setChildFoodData(foodDataId: String, dishID: Int)
    func setChildFoodData(foodDataId: String, productID: String)
    func setChildFoodData(foodDataId: String, customEntryID: String)
    func setChildFoodData(foodDataId: String, mealID: String)
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String], customEntriesID: [String])
    func getFoodData(_ food: Food) -> FoodData?
    func fetchSpecificRecipe(with id: String) -> Dish?
    @discardableResult func deleteMealData(_ id: String) -> Bool
    @discardableResult func delete<T>(_ object: T) -> Bool
    @discardableResult func setChildDailyMeal(
        mealTime: String,
        date: Day,
        mealDataId: [String]
    ) -> Bool
    @discardableResult func setFoodData(
        favorites: Bool?,
        date dateLastUse: Date?,
        numberUses: Int?,
        food: Food
    ) -> Bool
    @discardableResult func setChildMealData(
        mealDataId: String,
        dishID: Int?,
        productID: String?,
        customEntryID: String?,
        mealID: String?
    ) -> Bool
    
    func updateMeal(meal: Meal)
    func getDomainProduct(_ id: String) -> DomainProduct?
    func getDomainDish(_ id: Int) -> DomainDish?
    func getDomainCustomEntry(_ id: String) -> DomainCustomEntry?
}

final class LocalDomainService {
    private lazy var specificDishesFetchingContext = container.newBackgroundContext()
    // MARK: - Constants
    private let savingQueue: OperationQueue = {
      let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
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
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.overwrite
        return context
    }()
    
    private lazy var taskContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.safeMergePolicy
        return context
    }()
    
    // MARK: - Public Methods
    
    private func save() {
        guard taskContext.hasChanges else {
            return
        }
        
        let workItem = BlockOperation { [weak taskContext] in
            do {
                try taskContext?.save()
            } catch let error {
                taskContext?.rollback()
                print(error)
            }
        }
        
         taskContext.perform { [weak self] in
             self?.savingQueue.addOperation(workItem)
         }
    }
    
    private func deleteObject<T: NSManagedObject> (object: T) {
        context.delete(object)
        try? context.save()
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
    
    private func fetchDataAsynchronously<T: NSManagedObject> (
        for entity: T.Type,
        withPredicate predicate: NSCompoundPredicate? = nil,
        withSortDescriptor sortDescriptors: [NSSortDescriptor]? = nil,
        completion: @escaping ([T]?) -> Void
    ) {
        specificDishesFetchingContext.perform { [weak self] in
            do {
                let request = T.fetchRequest()
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                let fetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { result in
                    guard let result = result.finalResult as? [T] else {
                        completion([])
                        return
                    }
                    completion(result)
                }
                try self?.specificDishesFetchingContext.execute(fetchRequest)
            } catch {
                debugPrint("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    private func getDomainFoodData(_ foodDataId: String) -> DomainFoodData? {
        let format = "id == %@"
        
        let request = NSFetchRequest<DomainFoodData>(entityName: "DomainFoodData")
        request.predicate = NSPredicate(format: format, foodDataId)
        
        guard let domainFoodData = try? context.fetch(request).first else {
            return nil
        }
        return domainFoodData
    }
    
    func getDomainProduct(_ id: String) -> DomainProduct? {
        let format = "id == %@"
        
        let request = NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
        request.predicate = NSPredicate(format: format, id)
        
        guard let domainProduct = try? context.fetch(request).first else {
            return nil
        }
        
        return domainProduct
    }
    
   func getDomainDish(_ id: Int) -> DomainDish? {
        let format = "id == %id"
        
        let request = NSFetchRequest<DomainDish>(entityName: "DomainDish")
        request.predicate = NSPredicate(format: format, id)
        
        guard let domainDish = try? context.fetch(request).first else {
            return nil
        }
        
        return domainDish
    }
    
    func getDomainCustomEntry(_ id: String) -> DomainCustomEntry? {
        let format = "id == %@"
        
        let request = NSFetchRequest<DomainCustomEntry>(entityName: "DomainCustomEntry")
        request.predicate = NSPredicate(format: format, id)
        
        guard let domainCustomEntry = try? context.fetch(request).first else {
            return nil
        }
        
        return domainCustomEntry
    }
    
    private func getDomainMeal(_ id: String) -> DomainMeal? {
        let format = "id == %@"
        
        let request = NSFetchRequest<DomainMeal>(entityName: "DomainMeal")
        request.predicate = NSPredicate(format: format, id)
        
        guard let domainMeal = try? context.fetch(request).first else {
            return nil
        }
        
        return domainMeal
    }
}

// MARK: - LocalDomainServiceInterface
extension LocalDomainService: LocalDomainServiceInterface {
    func searchProducts(by phrase: String, completion: @escaping ([Product]) -> Void) {
        let phrases = phrase.split(whereSeparator: { $0.isWhitespace }).map { $0.lowercased() }.map { string in
            var newString = string
            newString.removeAll(where: { $0.isPunctuation || $0.isNumber || $0.isMathSymbol })
            return newString
        }
        let predicates: [NSCompoundPredicate] = phrases.compactMap { string in
            guard string.count > 2 else { return nil }
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", string)
            let brandPredicate = NSPredicate(format: "brand CONTAINS[cd] %@", string)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, brandPredicate])
            return compoundPredicate
        }
        
//        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", phrase)
//        let brandPredicate = NSPredicate(format: "brand CONTAINS[cd] %@", phrase)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchDataAsynchronously(for: DomainProduct.self, withPredicate: compoundPredicate) { products in
            completion(products?.compactMap { Product(from: $0) } ?? [])
        }
    }
    
    func searchProducts(barcode: String, completion: @escaping ([Product]) -> Void) {
        let barcodePredicate = NSPredicate(format: "barcode CONTAINS[cd] %@", barcode)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [barcodePredicate])
        fetchDataAsynchronously(for: DomainProduct.self, withPredicate: compoundPredicate) { products in
            completion(products?.compactMap { Product(from: $0) } ?? [])
        }
    }
    
    func searchDishes(by phrase: String, completion: @escaping ([Dish]) -> Void) {
        let phrases = phrase.split(whereSeparator: { $0.isWhitespace }).map { $0.lowercased() }.map { string in
            var newString = string
            newString.removeAll(where: { $0.isPunctuation || $0.isNumber || $0.isMathSymbol })
            return newString
        }
        
        let predicates: [NSPredicate] = phrases.compactMap { string in
            guard string.count > 2 else { return nil }
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", string)
            return predicate
        }

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchDataAsynchronously(for: DomainDish.self, withPredicate: compoundPredicate) { products in
            completion(products?.compactMap { Dish(from: $0) } ?? [])
        }
    }
    
    func fetchBreakfastDishes(completion: @escaping ([DomainDish]?) -> Void) {
        let p = NSPredicate(format: "(ANY eatingTags.id == %lld)", 8)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [p])
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchDataAsynchronously(
            for: DomainDish.self,
            withPredicate: compoundPredicate,
            withSortDescriptor: [sortDescriptor],
            completion: completion
        )
    }
    
    func fetchLunchDishes(completion: @escaping ([DomainDish]?) -> Void) {
        let p = NSPredicate(format: "(ANY eatingTags.id == %lld)", 9)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [p])
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchDataAsynchronously(
            for: DomainDish.self,
            withPredicate: compoundPredicate,
            withSortDescriptor: [sortDescriptor],
            completion: completion
        )
    }

    func fetchDinnerDishes(completion: @escaping ([DomainDish]?) -> Void) {
        let p = NSPredicate(format: "(ANY eatingTags.id == %lld)", 10)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [p])
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchDataAsynchronously(
            for: DomainDish.self,
            withPredicate: compoundPredicate,
            withSortDescriptor: [sortDescriptor],
            completion: completion
        )
    }

    func fetchSnackDishes(completion: @escaping ([DomainDish]?) -> Void) {
        let p = NSPredicate(format: "(ANY eatingTags.id == %lld)", 11)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [p])
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchDataAsynchronously(
            for: DomainDish.self,
            withPredicate: compoundPredicate,
            withSortDescriptor: [sortDescriptor],
            completion: completion
        )
    }
    
    func fetchBurnedKcals() -> [DailyData] {
        guard let domainKcals = fetchData(for: DomainBurnedEnergy.self) else { return [] }
        return domainKcals.compactMap { DailyData(from: $0) }
    }
    
    func fetchEatingTags() -> [DomainEatingTag] {
        guard let tags = fetchData(for: DomainEatingTag.self) else { return [] }
        return tags
    }

    func fetchProducts() -> [Product] {
        guard let domainProducts = fetchData(for: DomainProduct.self) else { return [] }
        return domainProducts.compactMap { Product(from: $0) }
    }
    
    func fetchDailyMeals() -> [DailyMeal] {
        guard let domainDailyMeals = fetchData(for: DomainDailyMeals.self) else { return [] }
        return domainDailyMeals.compactMap { DailyMeal(from: $0) }
    }
    
    func fetchDishes() -> [Dish] {
        let secondsStart = Date().timeIntervalSince1970
        guard let domainDishes = fetchData(for: DomainDish.self) else {
            return []
        }
        let secondsEnd = Date().timeIntervalSince1970
        print("Dishes fetch without mapping \(secondsEnd - secondsStart)")
        return domainDishes.compactMap { Dish(from: $0) }
    }
    
    func fetchDishesAsynchronously(completion: @escaping ([Dish]) -> Void) {
        let currentTime = Date().timeIntervalSince1970
        fetchDataAsynchronously(for: DomainDish.self) { dishes in
            guard let dishes = dishes else {
                completion([])
                return
            }
            let fetchTime = Date().timeIntervalSince1970
            print("Fetch time \(fetchTime - currentTime)")
            let mappedDishes = dishes.compactMap { Dish(from: $0) }
            let mappedTime = Date().timeIntervalSince1970
            print("Mapping time \(mappedTime - currentTime)")
            completion(mappedDishes)
        }
    }
    
    func fetchFoodData() -> [FoodData] {
        guard let domainFoodData = fetchData(for: DomainFoodData.self) else { return [] }
        print("Domain food data ")
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
    
    func fetchExercise() -> [Exercise] {
        guard let domainExercise = fetchData(for: DomainExercise.self) else {
            return []
        }
        return domainExercise.compactMap { Exercise(from: $0) }
    }
    
    func fetchNotes() -> [Note] {
        guard let domainNotes = fetchData(for: DomainNote.self) else {
            return []
        }
        return domainNotes.compactMap { Note(from: $0) }
    }
    
    func fetchCustomEntries() -> [CustomEntry] {
        guard let domainCustomEntries = fetchData(for: DomainCustomEntry.self) else {
            return []
        }
        
        return domainCustomEntries.compactMap { CustomEntry(from: $0) }
    }
    
    func saveProducts(products: [Product], saveInPriority: Bool) {
        
        let backgroundContext = container.newBackgroundContext()
        
        backgroundContext.mergePolicy = NSMergePolicy.safeMergePolicy
        
        backgroundContext.performAndWait {
            let _: [DomainProduct] = products
                .map { DomainProduct.prepare(fromPlainModel: $0, context: backgroundContext) }
            do {
                try backgroundContext.save()
            } catch let error {
                print(error)
                backgroundContext.rollback()
            }
        }
        //        }
        //        savingQueue.addOperation(operationBlock)
    }
    
    func saveDishes(dishes: [Dish]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy.safeMergePolicy
        
        backgroundContext.performAndWait {
            let _: [DomainDish] = dishes
                .map { DomainDish.prepare(fromPlainModel: $0, context: backgroundContext) }
            do {
              try backgroundContext.save()
            } catch let error {
                print(error)
                backgroundContext.rollback()
            }
        }
    }
    
    func saveDailyMeals(data: [DailyMeal]) {
        let _: [DomainDailyMeals] = data
            .map { DomainDailyMeals.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveMealData(data: [MealData]) {
        let _: [DomainMealData] = data
            .map { DomainMealData.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveMeals(meals: [Meal]) {
        let _: [DomainMeal] = meals
            .map { DomainMeal.prepare(from: $0, context: context) }
        try? context.save()
    }
    
    func saveWater(data: [DailyData]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        
        backgroundContext.performAndWait {
            let _: [DomainWater] = data
                .map { DomainWater.prepare(fromPlainModel: $0, context: backgroundContext) }
            try? backgroundContext.save()
        }
    }
    
    func saveSteps(data: [DailyData]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        backgroundContext.performAndWait {
            let _: [DomainSteps] = data
                .map { DomainSteps.prepare(fromPlainModel: $0, context: backgroundContext) }
            try? backgroundContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("UpdateStepsWidget"), object: nil)
        }
    }
    
    func saveBurnedKcal(data: [DailyData]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        backgroundContext.performAndWait {
            let _: [DomainBurnedEnergy] = data
                .map { DomainBurnedEnergy.prepare(fromPlainModel: $0, context: backgroundContext) }
            try? backgroundContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("UpdateMainWidget"), object: nil)
        }
    }
    
    func saveWeight(data: [DailyData]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
       
        backgroundContext.performAndWait {
            let _: [DomainWeight] = data
                .map { DomainWeight.prepare(fromPlainModel: $0, context: backgroundContext) }
            try? backgroundContext.save()
        }
    }
    
    func saveExercise(data: [Exercise]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
    
        backgroundContext.performAndWait {
            let _: [DomainExercise] = data
                .map { DomainExercise.prepare(fromPlainModel: $0, context: backgroundContext) }
            try? backgroundContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("UpdateExercisesWidget"), object: nil)
        }
    }
    
    func saveNotes(data: [Note]) {
        let _: [DomainNote] = data
            .map { DomainNote.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func saveCustomEntries(entries: [CustomEntry]) {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        
        let _: [DomainCustomEntry] = entries
            .map { DomainCustomEntry.prepare(fromPlainModel: $0, context: backgroundContext) }
        try? backgroundContext.save()
    }
    
    func updateMeal(meal: Meal) {
        let format = "id == %@"
       
        guard let domainMeal = fetchData(
            for: DomainMeal.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [NSPredicate(format: format, meal.id)]
            )
        )?.first else {
            debugPrint("No DomainMeal found with ID: \(meal.id)")
            return
        }
    
        if let components = domainMeal.components {
            domainMeal.removeFromComponents(components)
        }
        
        let newDomainMeal = DomainMeal.prepare(from: meal, context: context)
        context.performAndWait {
            do {
                try context.save()
            } catch {
                debugPrint("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    @discardableResult
    func delete<T>(_ object: T) -> Bool {
        let format = "id == %@"
        
        switch object.self {
        case is Note:
            guard let note = object as? Note else { return false }
            let request = NSFetchRequest<DomainNote>(entityName: "DomainNote")
            request.predicate = NSPredicate(format: format, note.id)
            guard let domainNote = try? context.fetch(request).first else { return false }
            context.delete(domainNote)
            try? context.save()
            return true
        default:
            return false
        }
    }
    
    func cleanDailyMealsConditionally() {
        let predicate = NSPredicate(format: "mealData.@count == 0")
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
        guard let domainDailyMeals = fetchData(for: DomainDailyMeals.self, withPredicate: compoundPredicate) else {
            return
        }
        domainDailyMeals.forEach { meal in
           context.delete(meal)
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func deleteMealData(_ id: String) -> Bool {
        let format = "id == %@"

        guard let mealData = fetchData(
            for: DomainMealData.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [NSPredicate(format: format, id)]
            )
        )?.first else {
            return false
        }
        deleteObject(object: mealData)
        cleanDailyMealsConditionally()
        return true
    }
    
    func deleteCustomEntry(_ id: String) {
        let format = "id == %@"
        
        guard let customEntry = fetchData(
            for: DomainCustomEntry.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [NSPredicate(format: format, id)]
            )
        )?.first else { return }
        deleteObject(object: customEntry)
        
    }
    
    func setChildFoodData(foodDataId: String, dishID: Int) {
        let format = "id == %ld"
        let dishRequest = NSFetchRequest<DomainDish>(entityName: "DomainDish")
        dishRequest.predicate = NSPredicate(format: format, dishID)
        
        guard let dish = try? context.fetch(dishRequest).first,
              let foodData = getDomainFoodData(foodDataId) else { return }
        
        foodData.dish = dish
        foodData.product = nil
        foodData.customEntry = nil
        foodData.meal = nil
        
        try? context.save()
    }
    
    func setChildFoodData(foodDataId: String, productID: String) {
        let format = "id == %@"
        let productRequest = NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
        productRequest.predicate = NSPredicate(format: format, productID)
        
        guard let product = try? context.fetch(productRequest).first,
              let foodData = getDomainFoodData(foodDataId) else { return }
        
        foodData.product = product
        foodData.dish = nil
        foodData.customEntry = nil
        foodData.meal = nil
        
        try? context.save()
    }
    
    func setChildFoodData(foodDataId: String, customEntryID: String) {
        let format = "id == %@"
        let customEntryRequest = NSFetchRequest<DomainCustomEntry>(entityName: "DomainCustomEntry")
        customEntryRequest.predicate = NSPredicate(format: format, customEntryID)
        
        guard let customEntry = try? context.fetch(customEntryRequest).first,
              let foodData = getDomainFoodData(foodDataId) else { return }
        
        foodData.customEntry = customEntry
        foodData.dish = nil
        foodData.product = nil
        foodData.meal = nil
        
        try? context.save()
    }
    
    func setChildFoodData(foodDataId: String, mealID: String) {
        let format = "id == %@"
        let mealRequest = NSFetchRequest<DomainMeal>(entityName: "DomainMeal")
        mealRequest.predicate = NSPredicate(format: format, mealID)
        
        guard let meal = try? context.fetch(mealRequest).first,
              let foodData = getDomainFoodData(foodDataId) else { return }
        
        foodData.meal = meal
        foodData.dish = nil
        foodData.product = nil
        foodData.customEntry = nil
        
        try? context.save()
    }
    
    func setFoodData(favorites: Bool?, date dateLastUse: Date?, numberUses: Int?, food: Food) -> Bool {
        let id = food.foodDataId
        let formatId = "id == %@"
        let predicate = NSPredicate(format: formatId, id ?? "")
        var propertiesToUpdate: [AnyHashable: Any] = [:]
        
        if let favorites = favorites {
            propertiesToUpdate["favorites"] = NSNumber(value: favorites)
        }
        
        if let dateLastUse = dateLastUse {
            propertiesToUpdate["dateLastUse"] = dateLastUse
        }
        
        if let numberUses = numberUses {
            propertiesToUpdate["numberUses"] = numberUses
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "DomainFoodData", in: context) else {
            return false
        }

        let updateRequest = NSBatchUpdateRequest(entity: entity)
        updateRequest.propertiesToUpdate = propertiesToUpdate
        updateRequest.resultType = .updatedObjectIDsResultType
        updateRequest.predicate = predicate
        updateRequest.affectedStores = container.persistentStoreCoordinator.persistentStores

        guard let batchUpdate = try? context.execute(updateRequest) as? NSBatchUpdateResult,
               let objectIDArray = batchUpdate.result as? [NSManagedObjectID]else {
            print("not update foodData ID - \(String(describing: id))")
            return false
        }
        
        let changes = [NSUpdatedObjectsKey: objectIDArray]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
        print("update foodData\n\(String(describing: batchUpdate.result))")
        return true
    }
    
    func getFoodData(_ food: Food) -> FoodData? {
        guard let id = food.foodDataId else {
            switch food {
            case .product(let product, _, _):
                guard let domainProduct = getDomainProduct(product.id), let domainFoodData = domainProduct.foodData else {
                    return nil
                }
                return FoodData(from: domainFoodData)
            case .dishes(let dish, _):
                guard let domainDish = getDomainDish(dish.id), let domainFoodData = domainDish.foodData else {
                    return nil
                }
                return FoodData(from: domainFoodData)
            case .meal(let meal):
                guard let domainMeal = getDomainMeal(meal.id),
                      let domainFoodData = domainMeal.foodData else {
                    return nil
                }
                return FoodData(from: domainFoodData)
            case .customEntry(let customEntry):
                guard let domainCustomEntry = getDomainCustomEntry(customEntry.id),
                      let domainFoodData = domainCustomEntry.foodData else {
                    return nil
                }
                return FoodData(from: domainFoodData)
                
            }
        }
        
        return getFoodData(id)
    }
    
    func getFoodData(_ id: String) -> FoodData? {
        guard let domainFoodData = getDomainFoodData(id) else {
            return nil
        }
        
        return FoodData(from: domainFoodData)
    }
    
    func setChildMeal(mealId: String, dishesID: [Int], productsID: [String], customEntriesID: [String]) {
        let format = "id == %ld"
        let formatMeal = "id == %@"

        let dishPredicates = dishesID.map { NSPredicate(format: format, $0) }
        let productPredicates = productsID.map { NSPredicate(format: formatMeal, $0) }
        let customEntryPredicates = customEntriesID.map { NSPredicate(format: formatMeal, $0) }
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

        let customEntries = customEntryPredicates.compactMap {
            fetchData(
                for: DomainCustomEntry.self,
                withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [$0])
            )?.first
        }

        guard let meal = fetchData(
            for: DomainMeal.self,
            withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [mealPredicate])
        )?.first else { return }

//        fetchData(for: DomainDish.self)?.forEach { meal.removeFromDishes($0) }
//        fetchData(for: DomainProduct.self)?.forEach { meal.removeFromProducts($0) }
//        fetchData(for: DomainCustomEntry.self)?.forEach { meal.removeFromCustomEntries($0) }
//        dishes.forEach { dish in
//            dish.foodData =
//        }

//        dishes.forEach {
//            meal.addToDishes($0)
//        }
//
//        products.forEach {
//            meal.addToProducts($0)
//        }
//
//        customEntries.forEach {
//            meal.addToCustomEntries($0)
//        }

        try? context.save()
    }
    
    func setChildDailyMeal(mealTime: String, date: Day, mealDataId: [String]) -> Bool {
        let formatStrId = "id == %@"
        let formatMealTime = "mealTime == %@"
        let formatMealDay = "day == %ld"
        let formatMealMonth = "month == %ld"
        let formatMealYear = "year == %ld"
        
        let mealDataPredicates = mealDataId.map { NSPredicate(format: formatStrId, $0) }
        let mealTimePredicate = NSPredicate(format: formatMealTime, mealTime)
        let mealDayPredicate = NSPredicate(format: formatMealDay, date.day)
        let mealMonthPredicate = NSPredicate(format: formatMealMonth, date.month)
        let mealYearPredicate = NSPredicate(format: formatMealYear, date.year)
        
        let mealData = mealDataPredicates.compactMap {
            fetchData(
                for: DomainMealData.self,
                withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [$0])
            )?.first
        }

        guard let meal = fetchData(
            for: DomainDailyMeals.self,
            withPredicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                mealTimePredicate,
                mealDayPredicate,
                mealMonthPredicate,
                mealYearPredicate
            ])
        )?.first else { return false }
        
        meal.addToMealData(NSSet(array: mealData))
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func setChildMealData(mealDataId: String,
                          dishID: Int?,
                          productID: String?,
                          customEntryID: String?,
                          mealID: String?) -> Bool {
        let formatId = "id == %ld"
        let formatStrId = "id == %@"
        
        var dishPredicate: NSPredicate?
        var productPredicate: NSPredicate?
        var customEntryPredicate: NSPredicate?
        var mealPredicate: NSPredicate?
        let mealDataPredicate = NSPredicate(format: formatStrId, mealDataId)
        
        if let dishID = dishID {
            dishPredicate = NSPredicate(format: formatId, dishID)
        } else if let productID = productID {
            productPredicate = NSPredicate(format: formatStrId, productID)
        } else if let customEntryID = customEntryID {
            customEntryPredicate = NSPredicate(format: formatStrId, customEntryID)
        } else if let mealID = mealID {
            mealPredicate = NSPredicate(format: formatStrId, mealID)
        }
        
        guard let mealData = fetchData(
            for: DomainMealData.self,
            withPredicate: NSCompoundPredicate(orPredicateWithSubpredicates: [
                mealDataPredicate
            ])
        )?.first else { return false }
        
        if let product = fetchData(
            for: DomainProduct.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [productPredicate].compactMap { $0 }
            )
        )?.first {
            mealData.product = product
        } else if let dish = fetchData(
            for: DomainDish.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [dishPredicate].compactMap { $0 }
            )
        )?.first {
            mealData.dish = dish
        } else if let customEntry = fetchData(
            for: DomainCustomEntry.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [customEntryPredicate].compactMap { $0 }
            )
        )?.first {
            mealData.customEntry = customEntry
        } else if let meal = fetchData(
            for: DomainMeal.self,
            withPredicate: NSCompoundPredicate(
                orPredicateWithSubpredicates: [mealPredicate].compactMap { $0 }
            )
        )?.first {
            mealData.meal = meal
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func saveFoodData(foods: [FoodData]) {
        let _: [DomainFoodData] = foods
            .map { DomainFoodData.prepare(fromPlainModel: $0, context: context) }
        try? context.save()
    }
    
    func searchProducts(by phrase: String) -> [Product] {
        var phrases = phrase.split(whereSeparator: { $0.isWhitespace }).map { $0.lowercased() }.map { string in
            var newString = string
            newString.removeAll(where: { $0.isPunctuation || $0.isNumber || $0.isMathSymbol})
            return newString
        }
        let predicates: [NSCompoundPredicate] = phrases.compactMap { string in
            guard string.count > 2 else { return nil }
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", string)
            let brandPredicate = NSPredicate(format: "brand CONTAINS[cd] %@", string)
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, brandPredicate])
            return compoundPredicate
        }
        
//        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", phrase)
//        let brandPredicate = NSPredicate(format: "brand CONTAINS[cd] %@", phrase)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
     
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
        let phrases = phrase.split(whereSeparator: { $0.isWhitespace }).map { $0.lowercased() }.map { string in
            var newString = string
            newString.removeAll(where: { $0.isPunctuation || $0.isNumber || $0.isMathSymbol })
            return newString
        }
        
        let predicates: [NSPredicate] = phrases.compactMap { string in
            guard string.count > 2 else { return nil }
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", string)
            return predicate
        }

        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
     
        guard let dishes = fetchData(
            for: DomainDish.self,
            withPredicate: compoundPredicate
        ) else {
            return []
        }
        return dishes.compactMap { Dish(from: $0) }.sorted { $0.title.count < $1.title.count }
    }
    
    func fetchSpecificRecipe(with id: String) -> Dish? {
        let predicate = NSPredicate(format: "id == %@", id)
        let dishRequest = NSFetchRequest<DomainDish>(entityName: "DomainDish")
        dishRequest.predicate = predicate
        guard let dish = try? context.fetch(dishRequest).first else { return nil }
        return Dish(from: dish)
    }
}
