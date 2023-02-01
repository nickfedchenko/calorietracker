//
//  DomainUserProduct+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.11.2022.
//

import CoreData

extension DomainProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainProduct> {
        return NSFetchRequest<DomainProduct>(entityName: "DomainProduct")
    }

    @NSManaged public var id: String
    @NSManaged public var isUserProduct: Bool
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
    @NSManaged public var units: Data?
    
    @NSManaged public var foodData: DomainFoodData?
}
