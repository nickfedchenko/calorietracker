//
//  DomainSteps+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData

@objc(DomainSteps)
public class DomainSteps: NSManagedObject {
    static func prepare(fromPlainModel model: DailyData, context: NSManagedObjectContext) -> DomainSteps {
        let steps = DomainSteps(context: context)
        steps.day = Int32(model.day.day)
        steps.month = Int32(model.day.month)
        steps.year = Int32(model.day.year)
        steps.value = model.value
        steps.isFromHK = model.isFromHK
        return steps
    }
}
