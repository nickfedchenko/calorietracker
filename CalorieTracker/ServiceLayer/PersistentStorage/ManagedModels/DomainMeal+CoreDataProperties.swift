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
    @NSManaged public var mealTime: String
    @NSManaged public var dishes: NSSet?
    @NSManaged public var products: NSSet?
    
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
    @NSManaged public func removeFromProducts(_ value: DomainDish)
    
    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)
    
    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)
    
}