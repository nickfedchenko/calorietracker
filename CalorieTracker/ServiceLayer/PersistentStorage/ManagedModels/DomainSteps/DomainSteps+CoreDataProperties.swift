//
//  DomainSteps+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData

extension DomainSteps: DomainDailyProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainSteps> {
        return NSFetchRequest<DomainSteps>(entityName: "DomainSteps")
    }

    @NSManaged public var day: Int32
    @NSManaged public var month: Int32
    @NSManaged public var year: Int32
    @NSManaged public var value: Double
}
