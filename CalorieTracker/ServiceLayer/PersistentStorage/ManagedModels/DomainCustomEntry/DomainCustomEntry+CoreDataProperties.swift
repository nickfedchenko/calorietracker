//
//  DomainCustomEntry+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 20.02.2023.
//

import CoreData

extension DomainCustomEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainCustomEntry> {
        return NSFetchRequest<DomainCustomEntry>(entityName: "DomainCustomEntry")
    }
    
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var kcal: Double
    @NSManaged public var carbs: Double
    @NSManaged public var proteins: Double
    @NSManaged public var fats: Double
    @NSManaged public var mealTime: String
    
    @NSManaged public var foodData: DomainFoodData?
}
