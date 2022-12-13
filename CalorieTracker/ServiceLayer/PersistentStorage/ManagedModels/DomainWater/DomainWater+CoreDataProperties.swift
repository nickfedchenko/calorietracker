//
//  DomainWater+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData

extension DomainWater: DomainDailyProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainWater> {
        return NSFetchRequest<DomainWater>(entityName: "DomainWater")
    }

    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var value: Double
}
