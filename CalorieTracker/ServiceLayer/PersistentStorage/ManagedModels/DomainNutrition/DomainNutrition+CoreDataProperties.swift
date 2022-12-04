//
//  DomainNutrition+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.12.2022.
//

import CoreData

extension DomainNutrition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainNutrition> {
        return NSFetchRequest<DomainNutrition>(entityName: "DomainNutrition")
    }

    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var kcal: Double
    @NSManaged public var fat: Double
    @NSManaged public var carbs: Double
    @NSManaged public var protein: Double
}
