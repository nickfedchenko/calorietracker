//
//  DomainDailyMeals+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.02.2023.
//

import CoreData

extension DomainDailyMeals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainDailyMeals> {
        return NSFetchRequest<DomainDailyMeals>(entityName: "DomainDailyMeals")
    }

    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var mealTime: String
    
    @NSManaged public var products: NSSet?
    @NSManaged public var dishes: NSSet?
}

extension DomainDailyMeals {
    
    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: DomainProduct)
    
    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: DomainProduct)
    
    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)
    
    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)
    
}

extension DomainDailyMeals {
    
    @objc(addDishesObject:)
    @NSManaged public func addToDishes(_ value: DomainDish)
    
    @objc(removeDishesObject:)
    @NSManaged public func removeFromDishes(_ value: DomainDish)
    
    @objc(addDishes:)
    @NSManaged public func addToDishes(_ values: NSSet)
    
    @objc(removeDishes:)
    @NSManaged public func removeFromDishes(_ values: NSSet)
    
}
