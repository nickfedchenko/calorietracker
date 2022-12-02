//
//  DomainWeight+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData

@objc(DomainWeight)
public class DomainWeight: NSManagedObject {
    static func prepare(fromPlainModel model: DailyData, context: NSManagedObjectContext) -> DomainWeight {
        let weight = DomainWeight(context: context)
        weight.day = Int32(model.day.day)
        weight.month = Int32(model.day.month)
        weight.year = Int32(model.day.year)
        weight.value = model.value
        return weight
    }
}

