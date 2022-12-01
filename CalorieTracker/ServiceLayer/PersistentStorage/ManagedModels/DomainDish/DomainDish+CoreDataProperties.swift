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
    @NSManaged public var kcal: Int16
    @NSManaged public var photo: URL?
    @NSManaged public var protein: Double
    @NSManaged public var title: String
    @NSManaged public var weight: Double
    @NSManaged public var servings: Int16
    @NSManaged public var videoURL: URL?
    @NSManaged public var updatedAt: String
    @NSManaged public var ingredients: Data?
    @NSManaged public var methods: Data?
    @NSManaged public var tags: Data?
    @NSManaged public var photos: Data?
    
    @NSManaged public var foodData: DomainFoodData?
}
