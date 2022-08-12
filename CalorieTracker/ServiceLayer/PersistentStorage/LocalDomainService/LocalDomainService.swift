//
//  LocalDomainService.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 11.08.2022.
//

import CoreData

protocol LocalDomainServiceInterface {
    func fetchProducts() -> [Product]
    func fetchDishes() -> [Dish]
    func saveProducts(products: [Product])
    func saveDishes(dishes: [Dish])
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
    
    private lazy var context = container.viewContext
    
    private lazy var taskContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        return context
    }()
    
    // MARK: - Public Methods
    
    private func save() {
        guard taskContext.hasChanges else { return }
        taskContext.perform { [taskContext] in
            do {
                try taskContext.save()
            } catch let error {
                taskContext.rollback()
                print(error)
            }
        }
    }
    
    private func deleteObject<T: NSManagedObject> (object: T) {
        taskContext.delete(object)
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
}

// MARK: - LocalDomainServiceInterface
extension LocalDomainService: LocalDomainServiceInterface {
    // TODO: - На подумать, маппинг отдать фасаду может?
    func fetchProducts() -> [Product] {
        guard let domainProducts = fetchData(for: DomainProduct.self) else { return [] }
        return domainProducts.compactMap { Product(from: $0) }
    }
    
    func fetchDishes() -> [Dish] {
        guard let domainDishes = fetchData(for: DomainDish.self) else { return [] }
        return domainDishes.compactMap { Dish(from: $0) }
    }
    
    func saveProducts(products: [Product]) {
        let _: [DomainProduct] = products
            .map { DomainProduct.prepare(fromPlainModel: $0, context: taskContext) }
        save()
    }
    
    func saveDishes(dishes: [Dish]) {
        let _: [DomainDish] = dishes
            .map { DomainDish.prepare(fromPlainModel: $0, context: taskContext) }
        save()
    }
}
