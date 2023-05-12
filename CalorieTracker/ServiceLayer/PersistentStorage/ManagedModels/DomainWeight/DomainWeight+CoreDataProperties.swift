//
//  DomainWeight+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData

extension DomainWeight: DomainDailyProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainWeight> {
        return NSFetchRequest<DomainWeight>(entityName: "DomainWeight")
    }

    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var value: Double
    @NSManaged public var isFromHK: Bool
}
