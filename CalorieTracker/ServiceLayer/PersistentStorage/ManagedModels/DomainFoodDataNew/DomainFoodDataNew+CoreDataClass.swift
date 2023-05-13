//
//  DomainFoodDataNew+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 12.05.2023.
//
//

import CoreData

@objc(DomainFoodDataNew)
public class DomainFoodDataNew: NSManagedObject {
    static func prepare(fromPlainModel model: FoodData, context: NSManagedObjectContext) -> DomainFoodDataNew {
        let foodData = DomainFoodDataNew(context: context)
        foodData.id = model.id
        foodData.numberOfUses = Int32(model.numberUses)
        foodData.isFavorite = model.favorites
        foodData.dateLastUse = model.dateLastUse
        switch model.food {
        case let .product(_, customAmount: customAmount, unit: unitData):
            switch (customAmount != nil, unitData != nil) {
            case (true, true):
                foodData.unitID = Int16(unitData?.unit.id ?? -1)
                foodData.unitCoefficient = unitData?.unit.getCoefficient() ?? 1
                foodData.unitLongTitle = unitData?.unit.getTitle(.long)
                foodData.unitShortTitle = unitData?.unit.getTitle(.short)
                foodData.unitAmount = unitData?.count ?? 1
            case (false, true):
                foodData.unitID = Int16(unitData?.unit.id ?? -1)
                foodData.unitCoefficient = unitData?.unit.getCoefficient() ?? 1
                foodData.unitLongTitle = unitData?.unit.getTitle(.long)
                foodData.unitShortTitle = unitData?.unit.getTitle(.short)
                foodData.unitAmount = unitData?.count ?? 1
            case (true, false):
                foodData.unitID = 1
                foodData.unitCoefficient = 1
                foodData.unitLongTitle = R.string.localizable.gram()
                foodData.unitShortTitle = R.string.localizable.gram()
                foodData.unitAmount = customAmount!
            case (false, false):
                foodData.unitID = -1
                foodData.unitCoefficient = -1
                foodData.unitLongTitle = R.string.localizable.gram()
                foodData.unitShortTitle = R.string.localizable.gram()
                foodData.unitAmount = -1
            }
        case let .dishes(_, customAmount: customAmount):
            foodData.unitID = 1
            foodData.unitCoefficient = 1
            foodData.unitAmount = customAmount ?? 0
            foodData.unitLongTitle = R.string.localizable.gram()
            foodData.unitShortTitle = R.string.localizable.gram()
        default:
            foodData.unitAmount = -1
            foodData.unitID = -1
            foodData.unitCoefficient = -1
            foodData.unitLongTitle = nil
            foodData.unitShortTitle = nil
        }
        return foodData
    }
}
