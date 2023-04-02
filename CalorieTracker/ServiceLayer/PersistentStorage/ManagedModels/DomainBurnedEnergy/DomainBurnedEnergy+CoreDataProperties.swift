//
//  DomainBurnedEnergy+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 26.03.2023.
//
//

import Foundation
import CoreData


extension DomainBurnedEnergy: DomainDailyProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainBurnedEnergy> {
        return NSFetchRequest<DomainBurnedEnergy>(entityName: "DomainBurnedEnergy")
    }

    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var value: Double

}
