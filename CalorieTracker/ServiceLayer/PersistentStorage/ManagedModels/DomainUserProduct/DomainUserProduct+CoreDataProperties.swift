//
//  DomainUserProduct+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.11.2022.
//

import CoreData

extension DomainUserProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainUserProduct> {
        return NSFetchRequest<DomainUserProduct>(entityName: "DomainUserProduct")
    }

    @NSManaged public var id: String
}
