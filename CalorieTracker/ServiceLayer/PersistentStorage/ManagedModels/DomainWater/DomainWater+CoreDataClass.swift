//
//  DomainWater+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData

@objc(DomainWater)
public class DomainWater: NSManagedObject {
    static func prepare(fromPlainModel model: DailyData, context: NSManagedObjectContext) -> DomainWater {
        let water = DomainWater(context: context)
        water.day = Int32(model.day.day)
        water.month = Int32(model.day.month)
        water.year = Int32(model.day.year)
        water.value = model.value
        return water
    }
}
