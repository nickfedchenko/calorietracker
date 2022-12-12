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
    @NSManaged public var barcode: String?
    @NSManaged public var title: String
    @NSManaged public var protein: Double
    @NSManaged public var fat: Double
    @NSManaged public var carbs: Double
    @NSManaged public var kcal: Double
    @NSManaged public var photo: Data?
    @NSManaged public var brand: String?
    @NSManaged public var composition: Data?
    @NSManaged public var servings: Data?
}
