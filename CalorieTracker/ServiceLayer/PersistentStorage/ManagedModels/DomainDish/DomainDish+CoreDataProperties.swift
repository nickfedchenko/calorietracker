//
//  DomainDish+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 12.08.2022.
//
//

import CoreData

extension DomainDish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainDish> {
        return NSFetchRequest<DomainDish>(entityName: "DomainDish")
    }

    @NSManaged public var carbs: Double
    @NSManaged public var cookTime: Int16
    @NSManaged public var fat: Double
    @NSManaged public var id: Int16
    @NSManaged public var info: String?
    @NSManaged public var kcal: Double
    @NSManaged public var photo: URL?
    @NSManaged public var protein: Double
    @NSManaged public var title: String
    @NSManaged public var weight: Double
    @NSManaged public var servings: Int16
    @NSManaged public var updatedAt: String
    @NSManaged public var ingredients: Data?
    @NSManaged public var methods: Data?
    @NSManaged public var eatingTags: Data?
    @NSManaged public var dishTypeTags: Data?
    @NSManaged public var processingTypeTags: Data?
    @NSManaged public var additionalTags: Data?
    @NSManaged public var dietTags: Data?
    @NSManaged public var exceptionTags: Data?
    
    @NSManaged public var foodData: DomainFoodData?
    @NSManaged public var dishWeightType: Int16
    @NSManaged public var isBool: Bool
    @NSManaged public var countries: Data?
    @NSManaged public var dishValues: Data?
    @NSManaged public var hundredValues: Data?
    @NSManaged public var servingValues: Data?
}
