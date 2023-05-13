//
//  DomainFoodDataNew+CoreDataProperties.swift
//  
//
//  Created by Vladimir Banushkin on 12.05.2023.
//
//

import Foundation
import CoreData


extension DomainFoodDataNew {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DomainFoodDataNew> {
        return NSFetchRequest<DomainFoodDataNew>(entityName: "DomainFoodDataNew")
    }

    @NSManaged public var dateLastUse: Date
    @NSManaged public var id: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var numberOfUses: Int32
    @NSManaged public var unitAmount: Double
    @NSManaged public var unitCoefficient: Double
    @NSManaged public var unitID: Int16
    @NSManaged public var unitLongTitle: String?
    @NSManaged public var unitShortTitle: String?
    @NSManaged public var customEntry: DomainCustomEntry?
    @NSManaged public var dish: DomainDish?
    @NSManaged public var meal: DomainMeal?
    @NSManaged public var product: DomainProduct?

}
