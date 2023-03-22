//
//  DomainPCFValues+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 22.03.2023.
//
//

import CoreData

@objc(DomainPCFValues)
public class DomainPCFValues: NSManagedObject {
    
    static func prepare(
        from model: DishValues,
        purposeString: String,
        context: NSManagedObjectContext, parentDishID: String
    ) -> DomainPCFValues {
        let values = DomainPCFValues(context: context)
        values.id = parentDishID + purposeString
        values.carbohydrates = model.carbohydrates
        values.kcal = model.kcal
        values.fats = model.fats
        values.proteins = model.proteins
        values.weight = model.weight ?? 0
        values.netCarbs = model.netCarbs
        return values
    }
}
