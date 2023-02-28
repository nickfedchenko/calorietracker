//
//  DomainMealData+CoreDataClass.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.02.2023.
//

import CoreData

@objc(DomainMealData)
public class DomainMealData: NSManagedObject {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    static func prepare(fromPlainModel model: MealData, context: NSManagedObjectContext) -> DomainMealData {
        let domainMealData = DomainMealData(context: context)
        domainMealData.id = model.id
        domainMealData.weight = model.weight
        switch model.food {
        case .product(_, customAmount: _, unit: let unitData):
            domainMealData.unitId = Int16(unitData?.unit.id ?? -1)
            domainMealData.unitCount = unitData?.count ?? -1
        default: return domainMealData
        }
        return domainMealData
    }
}
