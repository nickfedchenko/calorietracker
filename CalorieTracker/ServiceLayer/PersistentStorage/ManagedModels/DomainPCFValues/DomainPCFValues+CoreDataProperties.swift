//
//  DomainPCFValues+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 22.03.2023.
//
//

import CoreData

extension DomainPCFValues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainPCFValues> {
        return NSFetchRequest<DomainPCFValues>(entityName: "DomainPCFValues")
    }

    @NSManaged public var id: String?
    @NSManaged public var weight: Double
    @NSManaged public var netCarbs: Double
    @NSManaged public var proteins: Double
    @NSManaged public var fats: Double
    @NSManaged public var carbohydrates: Double
    @NSManaged public var kcal: Double
    @NSManaged public var dishHundredAssigned: DomainDish?
    @NSManaged public var dishFullAssigned: DomainDish?
    @NSManaged public var dishServingAssigned: DomainDish?

}
