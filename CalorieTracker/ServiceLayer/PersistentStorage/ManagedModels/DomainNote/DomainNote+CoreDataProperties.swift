//
//  DomainNote+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.01.2023.
//

import CoreData

extension DomainNote {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainNote> {
        return NSFetchRequest<DomainNote>(entityName: "DomainNote")
    }

    @NSManaged public var id: String
    @NSManaged public var date: Date
    @NSManaged public var text: String
    @NSManaged public var estimation: Int16
    @NSManaged public var imageUrl: URL?
}
