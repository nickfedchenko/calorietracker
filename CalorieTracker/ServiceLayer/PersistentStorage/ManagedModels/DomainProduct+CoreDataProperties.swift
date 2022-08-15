//
//  DomainProduct+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 11.08.2022.
//
//

import CoreData

extension DomainProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainProduct> {
        return NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
    }

    @NSManaged public var id: Int32
    @NSManaged public var barcode: String?
    @NSManaged public var title: String
    @NSManaged public var protein: Double
    @NSManaged public var fat: Double
    @NSManaged public var carbs: Double
    @NSManaged public var kcal: Int16
    @NSManaged public var photo: URL?
    @NSManaged public var isBasic: Bool
    @NSManaged public var isBasicState: Bool
    @NSManaged public var isDished: Bool
    @NSManaged public var brand: String?
    @NSManaged public var composition: Data?
    @NSManaged public var servings: Data?

}
