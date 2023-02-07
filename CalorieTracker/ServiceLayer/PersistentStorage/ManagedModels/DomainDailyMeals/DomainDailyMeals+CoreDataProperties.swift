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
    
    @NSManaged public var mealData: [DomainMealData]?
}

extension DomainDailyMeals {
    
    @objc(addMealData:)
    @NSManaged public func addToMealData(_ values: NSSet)
    
    @objc(removeProducts:)
    @NSManaged public func removeFromMealData(_ values: NSSet)
    
}
