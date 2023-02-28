//
//  DomainMealData+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.02.2023.
//

import CoreData

extension DomainMealData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainMealData> {
        return NSFetchRequest<DomainMealData>(entityName: "DomainMealData")
    }

    @NSManaged public var id: String
    @NSManaged public var weight: Double
    @NSManaged public var unitId: Int16
    
    @NSManaged public var dish: DomainDish?
    @NSManaged public var product: DomainProduct?
    @NSManaged public var customEntry: DomainCustomEntry?
}
