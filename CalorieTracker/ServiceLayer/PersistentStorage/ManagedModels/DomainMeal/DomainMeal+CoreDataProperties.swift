//
//  DomainMeal+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.11.2022.
//

import CoreData

extension DomainMeal {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainMeal> {
        return NSFetchRequest<DomainMeal>(entityName: "DomainMeal")
    }
    
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var mealTime: String
    @NSManaged public var dishes: NSSet?
    @NSManaged public var products: NSSet?
    @NSManaged public var customEntries: NSSet?
    @NSManaged public var photoURL: String
    
    @NSManaged public var foodData: DomainFoodData?
}

extension DomainMeal {
    
    @objc(addDishesObject:)
    @NSManaged public func addToDishes(_ value: DomainDish)
    
    @objc(removeDishesObject:)
    @NSManaged public func removeFromDishes(_ value: DomainDish)
    
    @objc(addDishes:)
    @NSManaged public func addToDishes(_ values: NSSet)
    
    @objc(removeDishes:)
    @NSManaged public func removeFromDishes(_ values: NSSet)
    
}

extension DomainMeal {
    
    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: DomainProduct)
    
    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: DomainProduct)
    
    @objc(addProducts:)
    @NSManaged public func addToProductsSet(_ values: NSSet)
    
    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)
    
}

extension DomainMeal {
    @objc(addCustomEntriesObject:)
    @NSManaged public func addToCustomEntries(_ value: DomainCustomEntry)
    
    @objc(addCustomEntries:)
    @NSManaged public func addToCustomEntriesSet(_ values: NSSet)
}
