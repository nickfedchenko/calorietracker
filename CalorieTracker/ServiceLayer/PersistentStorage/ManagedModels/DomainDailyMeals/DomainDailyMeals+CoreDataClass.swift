//
//  DomainDailyMeals+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 06.02.2023.
//

import CoreData

@objc(DomainDailyMeals)
public class DomainDailyMeals: NSManagedObject {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    static func prepare(fromPlainModel model: DailyMeal, context: NSManagedObjectContext) -> DomainDailyMeals {
        let dailyMeal = DomainDailyMeals(context: context)
        dailyMeal.day = Int32(model.date.day)
        dailyMeal.month = Int32(model.date.month)
        dailyMeal.year = Int32(model.date.year)
        dailyMeal.mealTime = model.mealTime.rawValue
        return dailyMeal
    }
}

