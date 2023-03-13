//
//  DomainFoodData+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.11.2022.
//

import CoreData

extension DomainFoodData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainFoodData> {
        return NSFetchRequest<DomainFoodData>(entityName: "DomainFoodData")
    }

    @NSManaged public var dateLastUse: Date
    @NSManaged public var favorites: Bool
    @NSManaged public var id: String
    @NSManaged public var numberUses: Int32
    
    @NSManaged public var dish: DomainDish?
    @NSManaged public var product: DomainProduct?
    @NSManaged public var customEntry: DomainCustomEntry?
    @NSManaged public var meal: DomainMeal?
}
