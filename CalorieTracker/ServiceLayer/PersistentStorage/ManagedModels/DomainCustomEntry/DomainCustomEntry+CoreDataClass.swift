//
//  DomainCustomEntry+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 20.02.2023.
//

import CoreData

@objc(DomainCustomEntry)
public class DomainCustomEntry: NSManagedObject {
    static func prepare(fromPlainModel model: CustomEntry, context: NSManagedObjectContext) -> DomainCustomEntry {
        let customEntry = DomainCustomEntry(context: context)
        
        customEntry.id = model.id
        customEntry.title = model.title
        customEntry.kcal = model.nutrients.kcal
        customEntry.carbs = model.nutrients.carbs
        customEntry.proteins = model.nutrients.proteins
        customEntry.fats = model.nutrients.fats
        customEntry.mealTime = model.mealTime.rawValue
        
        return customEntry
    }
}
