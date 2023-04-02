//
//  DomainBurnedEnergy+CoreDataClass.swift
//  
//
//  Created by Vladimir Banushkin on 26.03.2023.
//
//

import Foundation
import CoreData

@objc(DomainBurnedEnergy)
public class DomainBurnedEnergy: NSManagedObject {
    static func prepare(fromPlainModel model: DailyData, context: NSManagedObjectContext) -> DomainBurnedEnergy {
        let energy = DomainBurnedEnergy(context: context)
        energy.day = Int32(model.day.day)
        energy.month = Int32(model.day.month)
        energy.year = Int32(model.day.year)
        energy.value = model.value
        return energy
    }
}
